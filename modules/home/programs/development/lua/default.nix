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

  luaPkgs = pkgs.lua51Packages;

  cfg = config.${namespace}.programs.development.lua;
in
{
  options.${namespace}.programs.development.lua = {
    enable = mkBoolOpt false "Enable Lua.";

    package = mkOption {
      type = types.package;
      default = luaPkgs.lua;
      defaultText = literalExpression "pkgs.lua";
      description = "The Lua package to use.";
    };

    LSP = {
      enable = mkBoolOpt false "Enable LSP support for Lua.";
      packages = mkOption {
        type = types.package;
        default = pkgs.lua-language-server;
        description = "Package for Lua LSP.";
      };
    };

    formatter = {
      enable = mkBoolOpt false "Enable formatters for Lua.";
      packages = mkOption {
        type = types.package;
        default = pkgs.stylua;
        description = "Packages for Lua formatting.";
      };
    };

    linter = {
      enable = mkBoolOpt false "Enable linters for Lua.";
      packages = mkOption {
        type = types.package;
        default = pkgs.selene;
        description = "Packages for Lua linting.";
      };
    };

    other = {
      enable = mkBoolOpt false "Enable other tooling for Lua.";
      packages = mkOption {
        type = with types; listOf (uniq package);
        default = with pkgs; [
          luaPkgs.stdlib
          luaPkgs.luarocks
          luaPkgs.luafilesystem
          luaPkgs.jsregexp
          luaPkgs.sqlite
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
