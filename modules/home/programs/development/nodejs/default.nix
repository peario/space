{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf literalExpression mkOption types mkMerge mapAttrsToList;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.development.golang;
in {
  options.${namespace}.programs.development.golang = {
    enable = mkBoolOpt false "Enable golang.";

    package = mkOption {
      type = types.package;
      default = pkgs.go;
      defaultText = literalExpression "pkgs.go";
      description = "The Golang package to use.";
    };

    LSP = {
      enable = mkBoolOpt false "Enable LSP support for Golang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ gopls ];
        description = "Package for Golang LSP.";
      };
    };

    formatter = {
      enable = mkBoolOpt false "Enable formatters for Golang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        # NOTE(golang): goimports is included in gotools, maybe extract into it's own package?
        default = with pkgs; [ gotools gofumpt ];
        description = "Packages for Golang formatting.";
      };
    };

    linter = {
      enable = mkBoolOpt false "Enable linters for Golang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ revive ];
        description = "Packages for Golang linting.";
      };
    };

    DAP = {
      enable = mkBoolOpt false "Enable DAP for Golang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ delve ];
        description = "Packages for Golang debugging.";
      };
    };

    others = {
      enable = mkBoolOpt false "Add other tooling for Golang.";
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
        description = "Other packages for Golang.";
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
      description = "Packages to add to GOPATH.";
    };

    goPath = mkOption {
      type = with types; nullOr str;
      default = null;
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
      example = [ "extraGoPath1" "extraGoPath2" ];
      description = ''
        Extra {env}`GOPATH`s relative to {env}`HOME` appended
        after [](#opt-programs.go.goPath), if that option is set.
      '';
    };

    goBin = mkOption {
      type = with types; nullOr str;
      default = null;
      example = ".local/bin.go";
      description = "GOBIN relative to HOME";
    };

    goPrivate = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "*.corp.example.com" "rsc.io/private" ];
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
      home.packages = [ cfg.package ];

      home.file = let
        goPath = if cfg.goPath != null then cfg.goPath else "go";
        mkSrc = n: v: { "${goPath}/src/${n}".source = v; };
      in builtins.foldl' (a: b: a // b) { } (mapAttrsToList mkSrc cfg.packages);
    }

    (mkIf (cfg.goPath != null) {
      home.sessionVariables.GOPATH = builtins.concatStringsSep ":" (map
        (builtins.map (path: "${config.home.homeDirectory}/${path}")
          ([ cfg.goPath ] ++ cfg.extraGoPaths)));
    })

    (mkIf (cfg.goBin != null) {
      home.sessionVariables.GOBIN = "${config.home.homeDirectory}/${cfg.goBin}";
    })

    (mkIf (cfg.goPrivate != [ ]) {
      home.sessionVariables.GOPRIVATE =
        builtins.concatStringsSep "," cfg.goPrivate;
    })
  ]);
}
