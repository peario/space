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

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkEnableOption "Development suite";
    azure.enable = mkEnableOption "Azure development suite";
    docker.enable = mkEnableOption "Docker development suite";
    game.enable = mkEnableOption "Game development suite";
    kubernetes.enable = mkEnableOption "Kubernetes development suite";
    nix.enable = mkEnableOption "Nix development suite";
    sql.enable = mkEnableOption "SQL development suite";
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        [
          act
          eureka-ideas # TODO: Create alias for this one. Used to store ideas for later viewing
          fzf
          grex
          jqp
          neovide
          onefetch
          postman
          silicon
          tree-sitter
          ttyper
          xh
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          github-desktop
          qtcreator
          jetbrains-toolbox
          jetbrains.datagrip
        ]
        ++ lib.optionals cfg.nix.enable [
          nixpkgs-hammering
          nixpkgs-lint-community
          nixpkgs-review
          nix-update
          nix-init
          node2nix
          treefmt2
        ]
        ++ lib.optionals cfg.game.enable [
          godot_4
          # NOTE: removed from nixpkgs
          # ue4
          unityhub
        ]
        ++ lib.optionals cfg.sql.enable [
          dbeaver-bin
          mysql-workbench
        ];

      shellAliases = {
        prefetch-sri = "nix store prefetch-file $1";
      };
    };

    space = {
      programs = {
        development = {
          c = {
            enable = true;

            LSP = enabled;
            # DAP = enabled;
            docs = enabled;
            buildTools = enabled;
            other = enabled;
          };
          erlang = {
            enable = true;

            other = enabled;
          };
          go = enabled;
          lua = {
            enable = true;

            other = enabled;
          };
          nodejs = {
            enable = true;

            LSP = enabled;
            other = enabled;
            npmPackages = [
              "lite-server"
              "rimraf"
              "nodemon"
            ];
          };
          python = {
            enable = true;

            other = enabled;
          };
          rust = {
            enable = true;

            other = enabled;
          };
        };

        graphical = {
          editors = {
            vscode = enabled;
          };
        };

        terminal = {
          editors = {
            # helix = enabled;
            neovim = {
              enable = true;
              default = {
                editor = true;
                visual = true;
              };
            };
            # micro = enabled;
            emacs = {
              enable = true;
              daemon = enabled;
              # default = {
              #   editor = true;
              #   visual = true;
              # };
            };
          };

          tools = {
            azure.enable = cfg.azure.enable;
            commitizen = enabled;
            git-crypt = enabled;
            k9s.enable = cfg.kubernetes.enable;
            lazydocker.enable = cfg.docker.enable;
            lazygit = enabled;
          };
        };
      };
    };
  };
}
