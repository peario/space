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

  pyPkgs = pkgs.python312Packages;

  cfg = config.${namespace}.programs.development.python;
in
{
  options.${namespace}.programs.development.python = {
    enable = mkEnableOption "Python (v3.12)";

    package = mkOption {
      type = types.package;
      default = pyPkgs.python;
      description = "Package to use for Python.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Python";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          ruff # ruff is both formatter and linter
          pyright
        ];
        description = "Package for Python LSP.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Python";
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
      ++ lists.optionals cfg.other.enable cfg.other.packages
      ++ lists.optionals pkgs.stdenv.isLinux (with pkgs; [ jetbrains.pycharm-community ]);
  };
}
