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
  khanelinix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      graphical = {
        editors = {
          vscode = mkForce disabled;
        };
      };

      terminal = {
        emulators = {
          wezterm = mkForce disabled;
        };

        tools = {
          git = {
            enable = true;
            wslAgentBridge = true;
            # FIX: REPLACE %USERNAME%!!!!
            wslGitCredentialManagerPath = ''/mnt/c/Users/%USERNAME%/AppData/Local/Programs/Git/mingw64/bin/git-credential-manager.exe'';
            includes = [
              {
                condition = "gitdir:/mnt/c/";
                path = "${./git/windows-compat-config}";
              }
            ];
          };

          ssh = enabled;
        };
      };
    };

    services = {
      sops = {
        enable = true;
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/blitzar/nixos/default.yaml";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      };
    };

    system = {
      xdg = enabled;
    };

    suites = {
      business = enabled;
      common = enabled;
      development = {
        enable = true;
        docker.enable = true;
        kubernetes.enable = true;
      };
    };

    theme.catppuccin = enabled;
  };

  # sops.secrets.kubernetes = {
  #   path = "${config.home.homeDirectory}/.kube/config";
  # };

  home.stateVersion = "24.05";
}
