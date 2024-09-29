{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption lists;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkEnableOption "Development suite";
    docker.enable = mkEnableOption "Docker";
    podman.enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        "cutter"
        "jetbrains-toolbox"
        "visual-studio-code"
      ] ++ lists.optional cfg.docker.enable "docker" ++ lists.optional cfg.podman.enable "podman-desktop";

      brews = [
        "mas"
      ] ++ lists.optional cfg.docker.enable "whalebrew" ++ lists.optional cfg.podman.enable "podman";

      masApps = mkIf config.${namespace}.tools.homebrew.masEnable {
        "Patterns" = 429449079;
        "Xcode" = 497799835;
      };
    };
  };
}
