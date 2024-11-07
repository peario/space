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
    literalExpression
    mkOption
    mkEnableOption
    types
    mapAttrsToList
    mkMerge
    ;

  cfg = config.${namespace}.programs.development.go;
in
{
  options.${namespace}.programs.development.go = {
    enable = mkEnableOption "Go";

    package = mkOption {
      type = types.package;
      default = pkgs.go;
      description = "Package to use for Go.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Go";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ gopls ];
        description = "Package for Go LSP.";
      };
    };

    formatter = {
      enable = mkEnableOption "Formatters for Go";
      packages = mkOption {
        type = with types; listOf (uniq package);
        # NOTE(golang): goimports is included in gotools, maybe extract it into it's own package?
        default = with pkgs; [
          gotools
          gofumpt
        ];
        description = "Packages for Go formatting.";
      };
    };

    linter = {
      enable = mkEnableOption "Linters for Go";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ revive ];
        description = "Packages for Go linting.";
      };
    };

    DAP = {
      enable = mkEnableOption "DAP for Go";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ delve ];
        description = "Packages for Go debugging.";
      };
    };

    others = {
      enable = mkEnableOption "Other tooling for Go";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          iferr
          gomodifytags
          impl
          golines
          gotests
          gotestsum
          json-to-struct
          nilaway
        ];
        description = "Other packages for Go.";
      };
    };

    packages = mkOption {
      type = with types; attrsOf path;
      default = { };
      example = literalExpression ''
        {
          "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
          "golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
        }
      '';
      description = ''
        Packages to add to {env}`GOPATH`.
      '';
    };

    goPath = mkOption {
      type = with types; nullOr str;
      default = ".local/go";
      example = "go";
      description = ''
        Primary {env}`GOPATH` relative to
        {env}`HOME`. It will be exported first and therefore
        used by default by the Go tooling.
      '';
    };

    extraGoPaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "extraGoPath1"
        "extraGoPath2"
      ];
      description = ''
        Extra {env}`GOPATH`s relative to {env}`HOME` appended
        after [](#opt-programs.go.goPath), if that option is set.
      '';
    };

    goBin = mkOption {
      type = with types; nullOr str;
      default = ".local/go/bin";
      example = ".local/bin.go";
      description = "GOBIN relative to HOME";
    };

    goPrivate = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [
        "*.corp.example.com"
        "rsc.io/private"
      ];
      description = ''
        The {env}`GOPRIVATE` environment variable controls
        which modules the go command considers to be private (not
        available publicly) and should therefore not use the proxy
        or checksum database.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.jetbrains.goland ];
      # ++ lib.optional pkgs.stdenv.isDarwin pkgs.apple-sdk_15;
      # ++ lib.optionals pkgs.stdenv.isDarwin (
      #   with pkgs.darwin.apple_sdk.frameworks;
      #   [
      #     CoreFoundation
      #     CoreServices
      #   ]
      # );

      home.file =
        let
          goPath = if cfg.goPath != null then cfg.goPath else "go";
          mkSrc = n: v: { "${goPath}/src/${n}".source = v; };
        in
        builtins.foldl' (a: b: a // b) { } (mapAttrsToList mkSrc cfg.packages);
    }

    (mkIf (cfg.goPath != null) {
      home.sessionVariables.GOPATH = builtins.concatStringsSep ":" (
        map builtins.toPath (
          map (path: "${config.home.homeDirectory}/${path}") ([ cfg.goPath ] ++ cfg.extraGoPaths)
        )
      );
    })

    (mkIf (cfg.goBin != null) {
      home.sessionVariables.GOBIN = "${config.home.homeDirectory}/${cfg.goBin}";

      programs = {
        bash.initExtra = # bash
          ''
            export PATH="${config.home.homeDirectory}/${cfg.goBin}:$PATH"
          '';
        fish.shellInit = # fish
          ''
            fish_add_path -p "${config.home.homeDirectory}/${cfg.goBin}"
          '';
        zsh.initExtra = # bash
          ''
            export PATH="${config.home.homeDirectory}/${cfg.goBin}:$PATH"
          '';
      };
    })

    (mkIf (cfg.goPrivate != [ ]) {
      home.sessionVariables.GOPRIVATE = builtins.concatStringsSep "," cfg.goPrivate;
    })
  ]);
}
