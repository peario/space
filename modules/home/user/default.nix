{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkEnableOption
    mkDefault
    mkMerge
    getExe
    getExe'
    ;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.user;

  home-directory =
    if cfg.name == null then
      null
    else if pkgs.stdenv.isDarwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";

  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = # bash
      ''
        cp $src $out
      '';

    passthru = {
      fileName = defaultIconFileName;
    };
  };
  defaultIconFileName = "profile.png";
in
{
  options.${namespace}.user = {
    enable = mkEnableOption "Configure user account";
    email = mkOpt types.str "fredahl71@gmail.com" "Email of user account.";
    fullName = mkOpt types.str "Fredrik Dahlström" "Full name of user account.";
    home = mkOpt (types.nullOr types.str) home-directory "User's home directory.";
    icon = mkOpt (types.nullOr types.package) defaultIcon "User account's profile picture.";
    name = mkOpt (types.nullOr types.str) config.snowfallorg.user.name "The user account.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "${namespace}.user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "${namespace}.user.home must be set";
        }
      ];

      home = {
        file = {
          ".face".source = cfg.icon;
          ".face.icon".source = cfg.icon;
          "Desktop/.keep".text = "";
          "Documents/.keep".text = "";
          "Downloads/.keep".text = "";
          "Music/.keep".text = "";
          "Pictures/.keep".text = "";
          "Videos/.keep".text = "";
          "Pictures/${cfg.icon.fileName or (builtins.baseNameOf cfg.icon)}".source = cfg.icon;
        };

        homeDirectory = mkDefault cfg.home;

        shellAliases = {
          # nix specific aliases
          cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
          optimise = "nix-store --optimise -vv";
          bloat = "nix path-info -Sh /run/current-system";
          curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
          gc-check = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/w+-system|{memory|/proc)"'';
          repair = "nix-store --verify --check-contents --repair";
          run = "nix run";
          search = "nix search";
          shell = "nix shell";
          nixre = "${lib.optionalString pkgs.stdenv.isLinux "sudo"} flake switch";
          nix = "nix -vL";
          hmvar-reload = ''__HM_ZSH_SESS_VARS_SOURCED=0 source "/etc/profiles/per-user/${config.${namespace}.user.name}/etc/profile.d/hm-session-vars.sh"'';

          reload = # bash
            ''
              echo "[1] 'nix-collect-garbage --delete-older-than 3d && nix-collect-garbage-d'"
              nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d

              echo "[2] 'nix-store --verify --check-contents --repair'"
              nix-store --verify --check-contents --repair

              echo "[3] 'nix-store --optimise -vv'"
              nix-store --optimise -vv

              echo "[4] 'nix-index'"
              nix-index
            '';

          gsed = "${getExe pkgs.gnused}";

          # File management
          rcp = "${getExe pkgs.rsync} -rahP --mkpath --modify-window=1"; # Rsync copy keeping all attributes,timestamps,permissions"
          rmv = "${getExe pkgs.rsync} -rahP --mkpath --modify-window=1 --remove-sent-files"; # Rsync move keeping all attributes,timestamps,permissions
          tarnow = "${getExe pkgs.gnutar} -acf ";
          untar = "${getExe pkgs.gnutar} -zxvf ";
          wget = "${getExe pkgs.wget} -c ";

          # Navigation shortcuts
          home = "cd ~";
          conf = "cd ~/${namespace}";

          # Colorize output
          dir = "${getExe' pkgs.coreutils "dir"} --color=auto";
          egrep = "${getExe' pkgs.gnugrep "egrep"} --color=auto";
          fgrep = "${getExe' pkgs.gnugrep "fgrep"} --color=auto";
          grep = "${getExe pkgs.gnugrep} --color=auto";
          vdir = "${getExe' pkgs.coreutils "vdir"} --color=auto";

          # Misc
          cls = "clear";
          pls = "sudo";
          usage = "${getExe' pkgs.coreutils "du"} -ah -d1 | sort -rn 2>/dev/null";
          # If macOS, then use emacs29-pgtk (with patches), otherwise default emacs.
          emacs =
            mkIf (!config.${namespace}.programs.terminal.editors.emacs.daemon.enable)
              "${
                if pkgs.stdenv.isDarwin then (getExe' pkgs.emacs29-pgtk "emacs") else (getExe' pkgs.emacs "emacs")
              }";

          # Cryptography
          genpass = "${getExe pkgs.openssl} rand - base64 20"; # Generate a random, 20-charactered password
          sha = "shasum -a 256"; # Test checksum
          sshperm = # bash
            ''${getExe' pkgs.findutils "find"} .ssh/ -type f -exec chmod 600 {} \;; ${getExe' pkgs.findutils "find"} .ssh/ -type d -exec chmod 700 {} \;; ${getExe' pkgs.findutils "find"} .ssh/ -type f -name "*.pub" -exec chmod 644 {} \;'';
        };

        username = mkDefault cfg.name;
      };

      programs.home-manager = enabled;

      xdg.configFile = {
        "sddm/faces/.${cfg.name}".source = cfg.icon;
      };
    }
  ]);
}
