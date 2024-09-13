{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (lib.${namespace}) enabled disabled;
in
{
  space = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      graphical = {
        # bars = {
        #   sketchybar = enabled;
        # };

        browsers = {
          firefox = {
            hardwareDecoding = true;
            settings = {
              "dom.ipc.processCount.webIsolated" = 9;
              "dom.maxHardwareConcurrency" = 16;
              "media.av1.enabled" = false;
              "media.ffvpx.enabled" = false;
              "media.hardware-video-decoding.force-enabled" = true;
              "media.hardwaremediakeys.enabled" = true;
              "media.navigator.mediadatadecoder_vpx_enabled" = true;
              "media.rdd-vpx.enabled" = false;
            };
          };
        };

        editors = {
          vscode = mkForce disabled;
        };

        # apps = {
        #   _1password = enabled;
        # };
      };

      terminal = {
        tools = {
          ssh = {
            enable = true;

            authorizedKeys = [ ];
            sshAgent = true;
          };
        };
      };
    };

    # These services are from `<root>/modules/home/services`
    services = {
      sops = {
        enable = true;
        # TODO(sops): Update `shared` to `magnetar` or other device specific identifier
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      };
    };

    suites = {
      business = enabled;
      common = enabled;
      desktop = enabled;
      development = {
        enable = true;

        nix.enable = true;
      };
      music = enabled;
      networking = enabled;
      photo = enabled;
      social = enabled;
    };
  };

  home.stateVersion = "24.05";
}
