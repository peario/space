{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  imports = [
    ./hardware.nix
    ./network.nix
    ./specializations.nix
  ];

  space = {
    nix = enabled;

    archetypes = {
      gaming = enabled;
      personal = enabled;
      workstation = enabled;
    };

    display-managers = {
      gdm = {
        monitors = ./monitors.xml;
      };

      regreet = {
        hyprlandOutput = builtins.readFile ./hyprlandOutput;
      };
    };

    hardware = {
      audio = {
        enable = true;
        extra-packages = [ ];
      };
      bluetooth = enabled;
      cpu.amd = enabled;
      gpu = {
        amd = enabled;
        nvidia = enabled;
      };
      opengl = enabled;

      rgb = {
        openrgb.enable = true;
      };

      storage = {
        enable = true;

        btrfs = {
          enable = true;
          autoScrub = true;
          # dedupe = true;

          dedupeFilesystems = [ "nixos" ];

          scrubMounts = [
            "/"
            # "/mnt/steam"
          ];
        };

        ssdEnable = true;
      };

      tpm = enabled;
      yubikey = enabled;
    };

    programs = {
      graphical = {
        addons = {
          noisetorch = {
            enable = false;

            threshold = 95;
            # device = "alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_LT_191128065321F39907D0_111000-00.analog-stereo";
            # deviceUnit = "sys-devices-pci0000:00-0000:00:01.2-0000:02:00.0-0000:03:08.0-0000:08:00.3-usb3-3\x2d2-3\x2d2.1-3\x2d2.1.4-3\x2d2.1.4.3-3\x2d2.1.4.3:1.0-sound-card3-controlC3.device";
          };
        };

        wms = {
          hyprland = {
            enable = true;
          };

          sway = {
            enable = true;
          };
        };
      };
    };

    services = {
      avahi = enabled;
      # TODO: input-leap replace barrier
      geoclue = enabled;
      power = enabled;
      printing = enabled;

      snapper = {
        enable = true;

        configs = {
          Documents = {
            ALLOW_USERS = [ "peario" ];
            SUBVOLUME = "/home/peario/Documents";
            TIMELINE_CLEANUP = true;
            TIMELINE_CREATE = true;
          };
        };
      };

      openssh = {
        enable = true;

        authorizedKeys = [ ];
      };

      samba = {
        enable = true;

        shares = {
          public = {
            browseable = true;
            comment = "Home Public folder";
            only-owner-editable = false;
            path = "/home/${config.${namespace}.user.name}/Public/";
            public = true;
            read-only = false;
          };

          games = {
            browseable = true;
            comment = "Games folder";
            only-owner-editable = true;
            path = "/mnt/games/";
            public = true;
            read-only = false;
          };
        };
      };
    };

    security = {
      # doas = enabled;
      keyring = enabled;
      sudo-rs = enabled;
      sops = {
        enable = true;
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/comet/default.yaml";
      };
    };

    suites = {
      development = {
        enable = true;

        docker.enable = true;
        game.enable = true;
        kubernetes.enable = true;
        nix.enable = true;
        sql.enable = true;
      };
    };

    system = {
      boot = {
        enable = true;
        plymouth = true;
        boot = {
          secure = true;
          silent = true;
        };
      };

      fonts = enabled;
      locale = enabled;
      networking = {
        enable = true;
        optimizeTcp = true;
      };
      realtime = enabled;
      time = enabled;
    };
  };

  nix.settings = {
    # NOTE: Default (or previous) value is 24, current value (6) comes from cores in CPU
    cores = 6;
    max-jobs = 6;
  };

  services = {
    displayManager.defaultSession = "hyprland";
    rpcbind.enable = true; # needed for NFS
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
