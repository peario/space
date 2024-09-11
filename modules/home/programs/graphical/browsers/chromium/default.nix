{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.browsers.chromium;
in
{
  options.${namespace}.programs.graphical.browsers.chromium = {
    enable = mkEnableOption "Chromium";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      # extensions = with pkgs.chromium-extensions; [
      #   catppuccin.catppuccin-vsc
      #   eamodio.gitlens
      #   formulahendry.auto-close-tag
      #   formulahendry.auto-rename-tag
      #   github.chromium-github-actions
      #   github.chromium-pull-request-github
      #   gruntfuggly.todo-tree
      #   mkhl.direnv
      #   chromium-icons-team.vscode-icons
      #   wakatime.chromium-wakatime
      # ];
    };
  };
}
