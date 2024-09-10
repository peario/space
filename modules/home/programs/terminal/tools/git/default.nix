{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkForce getExe';
  inherit (lib.${namespace}) mkOpt mkBoolOpt enabled;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.terminal.tools.git;

  aliases = import ./aliases.nix;
  ignores = import ./ignores.nix;
in {
  options.${namespace}.programs.terminal.tools.git = {
    enable = mkEnableOption "Git";
    includes = mkOpt (types.listOf types.attrs) [ ]
      "Git includeIf paths and conditions.";
    signByDefault = mkOpt types.bool true "Sign commits by default.";
    signingKey =
      mkOpt types.str "${config.home.homeDirectory}/.ssh/id_ed25519.pub"
      "The key ID to sign commits with.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    wslAgentBridge = mkBoolOpt false "Enable the wsl agent bridge.";
    wslGitCredentialManagerPath = mkOpt types.str
      "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe"
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
        package = pkgs.gitFull;
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
            helper = if cfg.wslAgentBridge then
              cfg.wslGitCredentialManagerPath
            else if pkgs.stdenv.isLinux then
              "${getExe' config.programs.git.package
              "git-credential-libsecret"}"
            else
              "${getExe' config.programs.git.package
              "git-credential-osxkeychain"}";

            useHttpPath = true;
          };

          fetch = { prune = true; };

          gpg.format = "ssh";
          "gpg \"ssh\"".program = mkIf cfg._1password (""
            + "${lib.optionalString pkgs.stdenv.isLinux
            (getExe' pkgs._1password-gui "op-ssh-sign")}"
            + "${lib.optionalString pkgs.stdenv.isDarwin
            "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"}");

          commit = { gpgsign = true; };

          init = { defaultBranch = "master"; };

          lfs = enabled;

          pull = { rebase = true; };

          push = {
            autoSetupRemote = true;
            default = "current";
          };

          rebase = { autoStash = true; };

          safe = { directory = [ "~/${namespace}/" "/etc/nixos" ]; };
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
          hosts = [ "https://github.com" "https://gist.github.com" ];
        };

        settings = { version = "1"; };
      };

      bash.initExtra = # bash
        ''
          export GITHUB_TOKEN="$(cat ${
            config.sops.secrets."github/access-token".path
          })"
        '';
      fish.shellInit = # fish
        ''
          export GITHUB_TOKEN="(cat ${
            config.sops.secrets."github/access-token".path
          })"
        '';
      zsh.initExtra = # bash
        ''
          export GITHUB_TOKEN="$(cat ${
            config.sops.secrets."github/access-token".path
          })"
        '';
    };

    # NOTE: I don't need any of those.
    # home = {
    #   inherit (aliases) shellAliases;
    # };

    sops.secrets = {
      # TODO(sops): Figure out how to make access-token and ssh-key unique to each machine
      "github/access-token" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
        path = "${config.home.homeDirectory}/.config/gh/access-token";
      };
      # SSH stuff
      "git/ssh-key" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
        path = "${config.home.homeDirectory}/.ssh/ssh-key";
      };
      "git/ssh-key-priv" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      "git/ssh-key-pub" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/shared/default.yaml";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };
}
