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
    types
    lists
    ;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.development.erlang;
in
{
  options.${namespace}.programs.development.erlang = {
    enable = mkBoolOpt false "Enable Erlang.";

    # package = mkPackageOption pkgs "erlang_27" { };
    package = mkOption {
      type = types.package;
      default = pkgs.erlang_27;
      description = "Package to use for Erlang.";
    };

    LSP = {
      enable = mkBoolOpt false "Enable LSP support for Erlang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ erlang-ls ];
        description = "Package for Erlang LSP.";
      };
    };

    formatter = {
      enable = mkBoolOpt false "Enable formatters for Erlang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ erlfmt ];
        description = "Packages for Erlang formatting.";
      };
    };

    other = {
      enable = mkBoolOpt false "Enable other tooling for Erlang.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [ rebar3 ];
        description = "Other packages for Erlang.";
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
