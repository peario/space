{
  config,
  lib,
  pkgs,
  namespace,
  osConfig,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkIf
    mkForce
    getExe
    getExe'
    ;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.terminal.tools.git;

  aliases = import ./aliases.nix;
  ignores = import ./ignores.nix;

  tokenExports =
    lib.optionalString osConfig.${namespace}.security.sops.enable # Bash
      ''
        if [ -f ${config.sops.secrets."github/access-token".path} ]; then
          GITHUB_TOKEN="$(cat ${config.sops.secrets."github/access-token".path})"
          export GITHUB_TOKEN
          GH_TOKEN="$(cat ${config.sops.secrets."github/access-token".path})"
          export GH_TOKEN
        fi
      '';
in
{
  options.${namespace}.programs.terminal.tools.git = {
    enable = mkEnableOption "Git";
    includes = mkOpt (types.listOf types.attrs) [ ] "Git includeIf paths and conditions.";
    signByDefault = mkOpt types.bool true "Sign commits by default.";
    signingKey =
      mkOpt types.str "${config.home.homeDirectory}/.ssh/id_ed25519.pub"
        "The key ID to sign commits with.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    wslAgentBridge = mkBoolOpt false "Enable the wsl agent bridge.";
    wslGitCredentialManagerPath =
      mkOpt types.str "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe"
        "The windows git credential manager path.";
    _1password = mkBoolOpt false "Enable 1Password integration.";
  };

  config = mkIf cfg.enable {
    # TODO(git): Consider including linters/lsp/formatters/etc. for Workflows and Actions
    home.packages = with pkgs; [
      bfg-repo-cleaner
      git-crypt
      git-filter-repo
      git-lfs
      gitflow
      gitleaks
      gitlint
    ];

    programs = {
      git = {
        enable = true;
        # FIX: broken nixpkgs
        # package = pkgs.gitFull;
        inherit (cfg) includes userName userEmail;
        inherit (aliases) aliases;
        inherit (ignores) ignores;

        signing = {
          key = cfg.signingKey;
          inherit (cfg) signByDefault;
        };

        delta = {
          enable = true;

          options = {
            dark = true;
            features = mkForce "decorations side-by-side navigate";
            line-numbers = true;
            navigate = true;
            side-by-side = true;
          };
        };

        extraConfig = {
          credential = {
            helper =
              if cfg.wslAgentBridge then
                cfg.wslGitCredentialManagerPath
              else if pkgs.stdenv.isLinux then
                "${getExe' config.programs.git.package "git-credential-libsecret"}"
              else
                "${getExe' config.programs.git.package "git-credential-osxkeychain"}";

            useHttpPath = true;
          };

          fetch = {
            prune = true;
          };

          gpg.format = "ssh";
          "gpg \"ssh\"".program = mkIf cfg._1password (
            ""
            + "${lib.optionalString pkgs.stdenv.isLinux (getExe' pkgs._1password-gui "op-ssh-sign")}"
            + "${lib.optionalString pkgs.stdenv.isDarwin "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"}"
          );

          commit = {
            gpgsign = true;
          };

          merge = {
            conflictstyle = "diff3";
          };

          diff = {
            colorMoved = "default";
          };

          interactive = {
            diffFilter = "${getExe pkgs.delta} --color-only";
          };

          init = {
            defaultBranch = "master";
          };

          lfs = {
            smudge = "${getExe pkgs.git-lfs} smudge - - %f";
            process = "${getExe pkgs.git-lfs} filter-process";
            clean = "${getExe pkgs.git-lfs} clean -- %f";
            required = true;
          };

          core = {
            pager = "${getExe pkgs.delta}";
            editor = "${getExe pkgs.neovim-unwrapped}";
            longpaths = true;
          };

          pull = {
            rebase = true;
          };

          push = {
            autoSetupRemote = true;
            default = "current";
          };

          rebase = {
            autoStash = true;
          };

          safe = {
            directory = [
              "~/${namespace}/"
              "/etc/nixos"
            ];
          };
        };
      };

      gh = {
        enable = true;

        extensions = with pkgs; [
          gh-dash # dashboard with pull requests and issues
          gh-eco # explore the ecosystem
          gh-cal # contributions calender terminal viewer
          gh-poi # clean up local branches safely
        ];

        gitCredentialHelper = {
          enable = true;
          hosts = [
            "https://github.com"
            "https://gist.github.com"
          ];
        };

        settings = {
          version = "1";
        };
      };

      bash.initExtra = tokenExports;
      fish.shellInit = tokenExports;
      zsh.initExtra = tokenExports;
    };

    sops.secrets = mkIf osConfig.${namespace}.security.sops.enable {
      "github/access-token" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/peario/default.yaml";
        path = "${config.home.homeDirectory}/.config/gh/access-token";
      };
      # SSH
      "git/ssh-key" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/magnetar/peario/default.yaml";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      "git/ssh-key-pub" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/magnetar/peario/default.yaml";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };
}
