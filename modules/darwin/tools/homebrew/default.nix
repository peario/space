{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.tools.homebrew;
in
{
  options.${namespace}.tools.homebrew = {
    enable = mkBoolOpt false "Enable homebrew.";
    masEnable = mkBoolOpt false "Enable Mac App Store downloads.";
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;

      global = {
        brewfile = true;
        autoUpdate = true;
      };

      onActivation = {
        autoUpdate = true;
        cleanup = "uninstall";
        upgrade = true;
      };

      taps = [
        "homebrew/bundle"
        "homebrew/services"
      ];
    };
  };
}
