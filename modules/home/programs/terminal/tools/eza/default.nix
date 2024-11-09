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
    mkPackageOption
    mkOption
    types
    optionalAttrs
    optional
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.programs.terminal.tools.eza;
in
{
  options.${namespace}.programs.terminal.tools.eza = {
    enable = mkEnableOption "eza";

    enableIntegrations = mkEnableOption "Configures aliases for multiple shells";

    # shells = mkOption {
    #   type = types.listOf types.str;
    #   default = [ "bash" "zsh" "fish" "ion" "nushell" ];
    #   example = [ "bash" "zsh" ];
    #   description = "Which shells should integrations be done on.";
    # };

    aliases = mkOpt types.attrs {
      ls = "eza -a";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza -a --tree";
    } "Aliases to configure.";

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [
        "--group-directories-first"
        "--color=always"
      ];
      description = ''
        Extra command line options passed to eza.
      '';
    };

    icons = mkOption {
      type = types.str;
      default = "false";
      description = ''
        Display icons next to file names ({option}`--icons` argument).
      '';
    };

    git = mkOption {
      type = types.bool;
      default = false;
      description = ''
        List each file's Git status if tracked or ignored ({option}`--git` argument).
      '';
    };

    package = mkPackageOption pkgs "eza" { };
  };

  config =
    let
      icons =
        if cfg.icons == "true" then
          true
        else if cfg.icons == "auto" then
          "auto"
        else
          false;

      args = lib.escapeShellArgs (
        optional (icons != "auto") "--icons"
        ++ optional (icons == "auto") "--icons=auto"
        ++ optional cfg.git "--git"
        ++ cfg.extraOptions
      );

      optionsAlias = optionalAttrs (args != "") { eza = "eza ${args}"; };

      aliases = builtins.mapAttrs (_name: value: lib.mkDefault value) cfg.aliases;
    in
    mkIf cfg.enable {
      home.packages = [ cfg.package ];

      programs = {
        bash.shellAliases = optionsAlias // optionalAttrs cfg.enableIntegrations aliases;

        zsh.shellAliases = optionsAlias // optionalAttrs cfg.enableIntegrations aliases;

        fish.shellAliases = optionsAlias // optionalAttrs cfg.enableIntegrations aliases;

        # TODO(shell): Take a look at shells: Ion and Nushell
        # see: https://github.com/nix-community/home-manager/blob/master/modules/programs/eza.nix#L24-L40
        ion.shellAliases = optionsAlias // optionalAttrs cfg.enableIntegrations aliases;

        nushell.shellAliases = optionsAlias // optionalAttrs cfg.enableIntegrations aliases;
      };
    };
}
