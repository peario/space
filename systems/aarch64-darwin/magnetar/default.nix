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
      sops = {
        enable = true;
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/magnetar/peario/default.yaml";
      };
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

  nix.settings = {
    cores = 0; # Automatically try to use all available
    max-jobs = "auto"; # Automatically try to use all available
  };

  security.pam.enableSudoTouchIdAuth = true;

  users.users.${cfg.name} = {
    openssh = {
      authorizedKeys.keys = [ ];
    };
  };

  system.stateVersion = 5;
}
