{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled disabled;

  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = {
    enable = mkEnableOption "Common suite";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        # FIXME: broken nixpkgs
        # ncdu
        toilet
        tree
      ];

    space = {
      programs = {
        graphical = {
          browsers = {
            firefox = enabled;
          };
        };

        terminal = {
          emulators = {
            alacritty = {
              enable = false;
              font = "Monaspace Argon Var";
            };
            foot.enable = pkgs.stdenv.isLinux;
            kitty = {
              enable = true;
              font = "Monaspace Argon Var";
              fontSize = 15;
            };
            rio = {
              enable = false;
              font = "Monaspace Argon Var";
            };
            warp = disabled;
            wezterm = disabled;
          };

          shell = {
            bash = enabled;
            # fish = enabled;
            zsh = enabled;
            nushell = enabled;
          };

          tools = {
            bat = enabled;
            bottom = enabled;
            cachix = enabled;
            comma = enabled;
            direnv = enabled;
            eza = {
              enable = true;
              enableIntegrations = true;

              git = true;
              icons = "auto";

              extraOptions = [
                "--group-directories-first"
                "--color=always"
              ];
            };
            starship = enabled;
            fzf = enabled;
            fup-repl = enabled;
            git = {
              enable = true;

              _1password = true;
            };
            glxinfo.enable = pkgs.stdenv.isLinux;
            jq = enabled;
            ripgrep = enabled;
            tmux = enabled;
            # topgrade = enabled;
            # yazi = enabled;
            zoxide = enabled;
          };
        };
      };

      services = {
        # easyeffects.enable = pkgs.stdenv.isLinux;
        udiskie.enable = pkgs.stdenv.isLinux;
        tray.enable = pkgs.stdenv.isLinux;
      };

      theme = {
        gtk.enable = pkgs.stdenv.isLinux;
        qt.enable = pkgs.stdenv.isLinux;
      };
    };

    programs.readline = {
      enable = true;

      extraConfig = ''
        set completion-ignore-case on
      '';
    };

    xdg.configFile.wgetrc.text = "";
  };
}
