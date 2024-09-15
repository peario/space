{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.terminal.tools.k9s;
in
{
  options.${namespace}.programs.terminal.tools.k9s = {
    enable = mkEnableOption "k9s";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      helmfile
      kubecolor
      kubectl
      kubectx
      kubelogin
      kubernetes-helm
      kubeseal
    ];

    programs = {
      k9s = {
        enable = true;
        package = pkgs.k9s;

        settings.k9s = {
          liveViewAutoRefresh = true;
          refreshRate = 1;
          maxConnRetry = 3;
          ui = {
            enableMouse = true;
          };
        };
      };

      zsh.shellAliases = {
        k = "kubecolor";
        kc = "kubectx";
        kn = "kubens";
        ks = "kubeseal";
        kubectl = "kubecolor";
      };
    };
  };
}
