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
    types
    lists
    ;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.development.nodejs;
in
{
  options.${namespace}.programs.development.nodejs = {
    enable = mkBoolOpt false "Enable NodeJS (javascript and typescript).";

    package = mkOption {
      type = types.package;
      default = pkgs.nodejs_20;
      defaultText = literalExpression "pkgs.nodejs_20";
      description = "The NodeJS package to use.";
    };

    LSP = {
      enable = mkBoolOpt false "Enable LSP support for NodeJS.";
      packages = mkOption {
        type = types.package;
        default = pkgs.typescript;
        description = "Package for NodeJS LSP.";
      };
    };

    formatter = {
      enable = mkBoolOpt false "Enable formatters for NodeJS.";
      packages = mkOption {
        type = types.package;
        default = pkgs.nodePackages.prettier;
        description = "Packages for NodeJS formatting.";
      };
    };

    linter = {
      enable = mkBoolOpt false "Enable linters for NodeJS.";
      packages = mkOption {
        type = types.package;
        default = pkgs.nodePackages.eslint;
        description = "Packages for NodeJS linting.";
      };
    };

    other = {
      enable = mkBoolOpt false "Enable other tooling for NodeJS.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          bun
          yarn
          nodePackages.ts-node
        ];
        description = "Other packages for NodeJS.";
      };
    };

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
