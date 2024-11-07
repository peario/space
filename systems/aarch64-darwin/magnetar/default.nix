{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.user;
in
{
  space = {
    archetypes = {
      personal = enabled;
      workstation = enabled;
    };

    security = {
      sops = enabled;
    };

    suites = {
      art = enabled;
      common = enabled;
      desktop = enabled;
      development = enabled;
      games = enabled;
      music = enabled;
      networking = enabled;
      social = enabled;
      video = enabled;
      vm = enabled;
    };

    tools.homebrew.masEnable = false;
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];

  networking = {
    computerName = "Fredrik's MacBook Air";
    hostName = "magnetar";
    localHostName = "magnetar";

    knownNetworkServices = [ "Wi-Fi" ];
  };

  security.pam.enableSudoTouchIdAuth = true;

  users.users.${cfg.name} = {
    openssh = {
      authorizedKeys.keys = [ ];
    };
  };

  system.stateVersion = 5;
}
