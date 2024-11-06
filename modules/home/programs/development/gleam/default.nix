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

  cfg = config.${namespace}.programs.development.gleam;
in
{
  options.${namespace}.programs.development.gleam = {
    enable = mkEnableOption "Gleam";

    package = mkOption {
      type = types.package;
      default = pkgs.gleam;
      description = "Package to use for Gleam.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Gleam";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = [ ];
        description = "Package for Gleam LSP.";
      };
    };

    formatter = {
      enable = mkEnableOption "Formatters for Gleam";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = [ ];
        description = "Packages for Gleam formatting.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Gleam";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = [ ];
        description = "Other packages for Gleam.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [ cfg.package ]
      ++ lists.optionals cfg.LSP.enable cfg.LSP.packages
      ++ lists.optionals cfg.formatter.enable cfg.formatter.packages
      ++ lists.optionals cfg.other.enable cfg.other.packages;
  };
}
