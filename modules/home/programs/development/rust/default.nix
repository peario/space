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
          cargo-watch
          cargo-bloat
          cargo-expand
          cargo-sort
          cbfmt # required by nvim, formatting
          diesel-cli
          diesel-cli-ext
          dotenv-linter # required by nvim, diagnostics
          hyperfine # benchmarking
          rustycli
          rustywind # required by nvim, formatting
          silicon # screenshot tool
          skim # faster fzf
          systemfd
          wasm-bindgen-cli
          wasm-pack
          wasm-tools
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
