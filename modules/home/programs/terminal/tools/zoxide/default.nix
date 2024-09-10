{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.tools.zoxide;
in {
  options.${namespace}.programs.terminal.tools.zoxide = {
    enable = mkBoolOpt false "Enable zoxide.";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      package = pkgs.zoxide;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      # TODO(zoxide): Consider adding `nushell` integration as well

      options = [ "--cmd cd" ];
    };
  };
}
