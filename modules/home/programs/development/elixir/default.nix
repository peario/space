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

  cfg = config.${namespace}.programs.development.elixir;
in
{
  options.${namespace}.programs.development.elixir = {
    enable = mkEnableOption "Elixir";

    package = mkOption {
      type = types.package;
      default = pkgs.elixir;
      description = "Package to use for Elixir.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Elixir";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ elixir-ls ];
        description = "Package for Elixir LSP.";
      };
    };

    formatter = {
      enable = mkEnableOption "Formatters for Elixir";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = [ ];
        description = "Packages for Elixir formatting.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Elixir";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = [ ];
        description = "Other packages for Elixir.";
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
