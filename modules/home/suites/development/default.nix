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
          bruno
          dos2unix # Convert text files, from DOS to Mac or Linux line breaks
          # FIX: broken nixpkg
          # eureka-ideas # TODO: Create alias for this one. Used to store ideas for later viewing
          fzf
          grex
          jaq # Improved jq; JSON data processing tool.
          jqp
          libtool
          onefetch
          postman
          silicon
          sqruff # SQL linter
          squawk # Postgresql linter
          (tree-sitter.override {
            webUISupport = true;
          })
          ttyper
          xh
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          qtcreator
          jetbrains-toolbox
          jetbrains.datagrip
          # NOTE: "github-desktop" and "gitkraken" might have perm issues with "git" and "git lfs"
          github-desktop
          gitkraken
        ]
        ++ lib.optionals cfg.nix.enable [
          nil # Nix LSP
          nixpkgs-hammering
          nixpkgs-lint-community
          nixpkgs-review
          nixpkgs-fmt
          nixfmt-rfc-style
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
          postgresql
          sqlite
        ]
        ++ lib.optional (cfg.sql.enable && pkgs.stdenv.isLinux) mysql-workbench;

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
          elixir = enabled;
          erlang = {
            enable = true;

            other = enabled;
          };
          gleam = enabled;
          go = {
            enable = true;

            LSP = enabled;
            formatter = enabled;
            linter = enabled;
            other = enabled;
          };
          latex = {
            enable = true;

            LSP = enabled;
            other = enabled;
          };
          lua = {
            enable = true;

            other = enabled;
          };
          nodejs = {
            enable = true;

            LSP = enabled;
            other = enabled;
            npmPackages = [
              "@commitlint/config-conventional" # required by nvim, diagnostics
              "@commitlint/cli" # required by nvim, diagnostics
              "commitlint-format-json" # required by nvim, diagnostics
              "lite-server"
              "nodemon"
              "rimraf"
              "stylelint" # required by nvim, formatting
            ];
          };
          python = {
            enable = true;

            other = enabled;
          };
          rust = {
            enable = true;

            LSP = enabled;
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
            emacs = {
              enable = true;
              daemon = enabled;
              doom = enabled;

              # default = {
              #   editor = true;
              #   visual = true;
              # };
            };
            helix = enabled;
            # micro = enabled;
            neovim = {
              enable = true;

              default = {
                editor = true;
                visual = true;
              };
            };
            # vim = enabled;
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
