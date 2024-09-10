{ config, lib, pkgs, namespace, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.networking;
in {
  options.${namespace}.suites.networking = {
    enable = mkBoolOpt false "Enable networking configuration.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs;
      [ nmap openssh speedtest-cli ssh-copy-id ]
      ++ lib.optionals pkgs.stdenv.isLinux [ iproute2 ];
  };
}
