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
    mkEnableOption
    mkOption
    types
    lists
    ;

  cfg = config.${namespace}.programs.development.nodejs;
in
{
  options.${namespace}.programs.development.nodejs = {
    enable = mkEnableOption "Node.js (JS and TS)";

    package = mkOption {
      type = types.package;
      default = pkgs.nodejs_20;
      description = "Package to use for Node.js.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Node.js";
      packages = mkOption {
        type = types.package;
        default = pkgs.typescript;
        description = "Package for Node.js LSP.";
      };
    };

    formatter = {
      enable = mkEnableOption "Formatters for Node.js";
      packages = mkOption {
        type = types.package;
        default = pkgs.nodePackages.prettier;
        description = "Packages for Node.js formatting.";
      };
    };

    linter = {
      enable = mkEnableOption "Linters for Node.js";
      packages = mkOption {
        type = types.package;
        default = pkgs.nodePackages.eslint;
        description = "Packages for Node.js linting.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Node.js";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          bun
          yarn
          nodePackages.ts-node
        ];
        description = "Other packages for Node.js.";
      };
    };

    # TODO(node.js): Setup automatic install via NPM for npm-packages.
    installPackages = mkOption {
      type = with types; listOf (uniq str);
      default = [ ];
      example = [
        "lite-server"
        "tailwindcss"
      ];
      description = "Packages to install via NPM.";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [ cfg.package ]
      ++ lists.optional cfg.LSP.enable cfg.LSP.packages
      ++ lists.optional cfg.formatter.enable cfg.formatter.packages
      ++ lists.optional cfg.linter.enable cfg.linter.packages
      ++ lists.optionals cfg.other.enable cfg.other.packages;
    # ++ lists.optional ((builtins.length cfg.installPackages) > 0) cfg.installPackages;
  };
}
