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

  luaPkgs = pkgs.lua51Packages;

  cfg = config.${namespace}.programs.development.lua;
in
{
  options.${namespace}.programs.development.lua = {
    enable = mkEnableOption "Lua";

    package = mkOption {
      type = types.package;
      default = luaPkgs.lua;
      description = "Package to use for Lua.";
    };

    LSP = {
      enable = mkEnableOption "LSP for Lua";
      packages = mkOption {
        type = types.package;
        default = pkgs.lua-language-server;
        description = "Package for Lua LSP.";
      };
    };

    formatter = {
      enable = mkEnableOption "Formatters for Lua";
      packages = mkOption {
        type = types.package;
        default = pkgs.stylua;
        description = "Packages for Lua formatting.";
      };
    };

    linter = {
      enable = mkEnableOption "Linters for Lua";
      packages = mkOption {
        type = types.package;
        default = pkgs.selene;
        description = "Packages for Lua linting.";
      };
    };

    other = {
      enable = mkEnableOption "Other tooling for Lua";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with luaPkgs; [
          stdlib
          luarocks
          luafilesystem
          jsregexp
          sqlite
        ];
        description = "Other packages for Lua.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [ cfg.package ]
      ++ lists.optional cfg.LSP.enable cfg.LSP.packages
      ++ lists.optional cfg.formatter.enable cfg.formatter.packages
      ++ lists.optional cfg.linter.enable cfg.linter.packages
      ++ lists.optionals cfg.other.enable cfg.other.packages;
  };
}
