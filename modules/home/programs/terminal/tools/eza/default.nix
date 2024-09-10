{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib)
    mkIf mkPackageOption mkOption types escapeShellArgs optionalAttrs optional;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.programs.terminal.tools.eza;
in rec {
  options.${namespace}.programs.terminal.tools.eza = {
    enable = mkBoolOpt false "Enable eza.";

    enableIntegrations =
      mkBoolOpt true "Configures aliases for multiple shells.";

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
      type = types.listOf types.str;
      default = [ ];
      example = [ "--group-directories-first" "--color=always" ];
      description = ''
        Extra command line options passed to eza.
      '';
    };

    icons = mkOption {
      type = types.bool;
      default = false;
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

  config = let
    args = lib.escapeShellArgs (optional cfg.icons "--icons"
      ++ optional cfg.git "--git" ++ cfg.extraOptions);

    optionsAlias = optionalAttrs (args != "") { eza = "eza ${args}"; };

    aliases = builtins.mapAttrs (_name: value: lib.mkDefault value) cfg.aliases;
  in mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs = {
      bash.shellAliases = optionsAlias
        // optionalAttrs cfg.enableIntegrations aliases;

      zsh.shellAliases = optionsAlias
        // optionalAttrs cfg.enableIntegrations aliases;

      fish.shellAliases = optionsAlias
        // optionalAttrs cfg.enableIntegrations aliases;

      # TODO(shell): Take a look at shells: Ion and Nushell
      # see: https://github.com/nix-community/home-manager/blob/master/modules/programs/eza.nix#L24-L40
      ion.shellAliases = optionsAlias
        // optionalAttrs cfg.enableIntegrations aliases;

      nushell.shellAliases = optionsAlias
        // optionalAttrs cfg.enableIntegrations aliases;
    };
  };
}
