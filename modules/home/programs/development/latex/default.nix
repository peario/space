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

  cfg = config.${namespace}.programs.development.latex;
in
{
  options.${namespace}.programs.development.latex = {
    enable = mkEnableOption "LaTeX";

    package = mkOption {
      type = types.package;
      # default = pkgs.texliveMedium; # This contains formatter, linter, etc.
      default = pkgs.texliveBookPub;
      description = "Package to use for LaTeX.";
    };

    LSP = {
      enable = mkEnableOption "LSP for LaTeX";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ texlab ];
        description = "Package for LaTeX LSP.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for LaTeX";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default =
          with pkgs;
          [
            # LaTeX backend
            # NOTE: added with `pkgs.texliveBookPub`
            # biber
          ]
          ++ lists.optionals pkgs.stdenv.isLinux [
            # Sioyek on Mac is installed via homebrew, zathura exists as "home package".
            sioyek

            # To use Forward Search with zathura
            xdotool
          ];
        description = "Other packages for LaTeX.";
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
