{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = {
    enable = mkEnableOption "Common suite";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      nixcfg = "nvim ~/${namespace}/flake.nix";
    };

    home.packages =
      with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        ncdu
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
            # alacritty = enabled;
            foot.enable = pkgs.stdenv.isLinux;
            kitty = enabled;
            rio = enabled;
            # warp = enabled;
            # wezterm = enabled;
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
            # btop = enabled;
            # colorls = enabled;
            cachix = enabled;
            comma = enabled;
            direnv = enabled;
            eza = {
              enable = true;
              enableIntegrations = true;

              git = true;
              icons = true;

              extraOptions = [
                "--group-directories-first"
                "--color=always"
              ];
            };
            starship = enabled;
            # fastfetch = enabled;
            fzf = enabled;
            fup-repl = enabled;
            git = {
              enable = true;

              _1password = true;
            };
            glxinfo.enable = pkgs.stdenv.isLinux;
            jq = enabled;
            # lsd = enabled;
            # oh-my-posh = enabled;
            ripgrep = enabled;
            tmux = enabled;
            # topgrade = enabled;
            # yazi = enabled;
            # zellij = enabled;
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
