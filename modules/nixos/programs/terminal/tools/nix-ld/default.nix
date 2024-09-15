{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  system,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (inputs) nix-ld-rs;

  cfg = config.${namespace}.programs.terminal.tools.nix-ld;
in
{
  options.${namespace}.programs.terminal.tools.nix-ld = {
    enable = mkEnableOption "nix-ld";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      package = nix-ld-rs.packages.${system}.nix-ld-rs;

      libraries = with pkgs; [
        gcc
        icu
        libcxx
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };
}
