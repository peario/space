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

    LSP = {
      enable = mkEnableOption "LSP for Rust";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ rust-analyzer ];
        description = "Package for Rust LSP.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Rust";
      packages = mkOption {
        type = with types; listOf package;
        default = with pkgs; [
          cbfmt # required by nvim, formatting
          dotenv-linter # required by nvim, diagnostics
          hyperfine # benchmarking
          cargo-watch
          cargo-bloat
          cargo-expand
          cargo-sort
          rustycli
          rustywind # required by nvim, formatting
          # rustPlatform.bindgenHook
          silicon # screenshot tool
          skim # faster fzf
          systemfd
          # FIX: Broken install
          # trunk
          wasm-pack
          wasm-tools
          wasm-bindgen-cli
          # FIX: Broken install
          # zig
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
        ++ lists.optionals pkgs.stdenv.isLinux (with pkgs; [ jetbrains.rust-rover ])
        ++ lib.optional pkgs.stdenv.isDarwin pkgs.apple-sdk_15;
      # ++ lists.optionals pkgs.stdenv.isDarwin (
      #   with pkgs.darwin.apple_sdk.frameworks;
      #   [
      #     # TODO(apple_sdk): Check if all of them are necessary. Maybe extract somewhere else and
      #     # make "opt-in"?
      #     # For macOS systems
      #     CoreServices
      #     CoreFoundation
      #     Foundation
      #     AppKit
      #   ]
      # );

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
            pkgs.openssl.dev
          ]
        );
        OPENSSL_DIR = mkIf pkgs.stdenv.isDarwin "/opt/homebrew/opt/openssl";
      };
    };
  };
}
