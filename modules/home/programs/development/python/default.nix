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

  pyPkgs = pkgs.python312Packages;

  cfg = config.${namespace}.programs.development.python;
in
{
  options.${namespace}.programs.development.python = {
    enable = mkBoolOpt false "Enable Python.";

    package = mkOption {
      type = types.package;
      default = pyPkgs.python;
      defaultText = literalExpression "pkgs.python312Packages.python";
      description = "The Python package to use.";
    };

    LSP = {
      enable = mkBoolOpt false "Enable LSP support for Python.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          ruff
          pyright
        ];
        description = "Package for Python LSP.";
      };
    };

    other = {
      enable = mkBoolOpt false "Enable other tooling for Python.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default =
          with pkgs;
          [
            pipenv
            pipreqs
            poetry
          ]
          ++ (with pyPkgs; [
            pip
            pynvim
            pipx
            distutils-extra
            distlib
          ]);
        description = "Other packages for Python.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [ cfg.package ]
      ++ lists.optionals cfg.LSP.enable cfg.LSP.packages
      ++ lists.optionals cfg.other.enable cfg.other.packages;
  };
}
