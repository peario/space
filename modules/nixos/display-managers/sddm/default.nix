{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    getExe'
    stringAfter
    ;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.display-managers.sddm;
in
{
  options.${namespace}.display-managers.sddm = {
    enable = mkEnableOption "sddm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      catppuccin-sddm-corners
      sddm
    ];

    services = {
      displayManager = {
        sddm = {
          inherit (cfg) enable;
          theme = "catppuccin-sddm-corners";
          wayland = enabled;
        };
      };
    };

    system.activationScripts.postInstallSddm =
      stringAfter [ "users" ] # bash
        ''
          echo "Setting sddm permissions for user icon"
          ${getExe' pkgs.acl "setfacl"} -m u:sddm:x /home/${config.${namespace}.user.name}
          ${getExe' pkgs.acl "setfacl"} -m u:sddm:r /home/${config.${namespace}.user.name}/.face.icon || true
        '';
  };
}
