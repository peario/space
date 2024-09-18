{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    lists
    ;

  cfg = config.${namespace}.programs.development.rust;
in
{
  options.${namespace}.programs.development.rust = {
    enable = mkEnableOption "Rust (depends on C)";

    package = mkOption {
      type = types.package;
      default = pkgs.rustup;
      description = "Package to use for Rust.";
    };

    other = {
      enable = mkEnableOption "Other tooling for Rust";
      packages = mkOption {
        type = with types; listOf package;
        default = with pkgs; [
          rustycli
          systemfd
          cargo-watch
          cargo-bloat
          cargo-expand
          cargo-sort
          wasm-pack
          wasm-tools
          wasm-bindgen-cli
          trunk
          silicon
        ];
        description = "Other packages for Rust.";
      };
    };

    cargoHome = mkOption {
      type = types.str;
      default = ".cargo";
      description = ''
        Sets {env}`CARGO_HOME` relative to {env}`HOME`.
      '';
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        [ cfg.package ]
        ++ lists.optionals cfg.other.enable cfg.other.packages
        ++ lists.optionals pkgs.stdenv.isDarwin (
          with pkgs.darwin.apple_sdk.frameworks;
          [
            # TODO(apple_sdk): Check if all of them are necessary. Maybe extract somewhere else and
            # make "opt-in"?
            # For macOS systems
            Security
            CoreServices
            CoreFoundation
            Foundation
            AppKit
            IOKit
          ]
        );

      sessionVariables = {
        CARGO_HOME = "${config.home.homeDirectory}/${cfg.cargoHome}";
        PATH = builtins.concatStringsSep ":" [
          "${config.home.homeDirectory}/${cfg.cargoHome}/bin"
          "$PATH"
        ];
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        # Add precompiled library to rustc search path
        RUSTFLAGS = builtins.concatStringsSep " " (
          builtins.map (a: ''-L ${a}/lib'') [
            # add libraries here (e.g. pkgs.libvmi)
            pkgs.libiconv
          ]
        );
      };
    };
  };
}
