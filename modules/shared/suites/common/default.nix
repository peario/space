{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = {
    enable = mkEnableOption "Common suite";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        coreutils-prefixed
        # NOTE: Doom Emacs wants coreutils-prefixed
        # coreutils
        fd
        file
        findutils
        killall
        lsof
        pciutils
        tldr
        unzip
        wget
        xclip
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # installing curl on MacOS causes issues with Homebrew
        curl
      ];
  };
}
