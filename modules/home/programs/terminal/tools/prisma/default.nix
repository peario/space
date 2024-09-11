{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    getExe'
    ;

  cfg = config.${namespace}.programs.terminal.tools.prisma;
in
{
  # TODO(prisma): Is this needed? Anything needs adjusting?
  options.${namespace}.programs.terminal.tools.prisma = {
    enable = mkEnableOption "Prisma";
    pkgs = {
      npm = mkPackageOption pkgs.nodePackages "prisma" {
        extraDescription = "The NPM package to install";
      };
      engines = mkPackageOption pkgs "prisma-engines" {
        extraDescription = "The package to get prisma engines from";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.pkgs.npm ];

    programs.zsh.initExtra = # bash
      ''
        export PRISMA_MIGRATION_ENGINE_BINARY="${getExe' cfg.pkgs.engines "migration-engine"}"
        export PRISMA_QUERY_ENGINE_BINARY="${getExe' cfg.pkgs.engines "query-engine"}"
        export PRISMA_QUERY_ENGINE_LIBRARY="${cfg.pkgs.engines}/lib/libquery_engine.node"
        export PRISMA_INTROSPECTION_ENGINE_BINARY="${getExe' cfg.pkgs.engines "introspection-engine"}"
        export PRISMA_FMT_BINARY="${getExe' cfg.pkgs.engines "prisma-fmt"}"
      '';
  };
}
