{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) default-attrs;

  cfg = config.${namespace}.system.boot;
  themeCfg = config.${namespace}.theme;
in
{
  options.${namespace}.system.boot = {
    enable = mkEnableOption "booting";
    plymouth = mkEnableOption "Plymouth boot splash";
    boot = {
      secure = mkEnableOption "Secure boot";
      silent = mkEnableOption "Silent boot";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        efibootmgr
        efitools
        efivar
        fwupd
      ]
      ++ lib.optionals cfg.boot.secure [ sbctl ];

    boot = {
      kernelParams =
        lib.optionals cfg.plymouth [ "quiet" ]
        ++ lib.optionals cfg.boot.silent [
          # tell the kernel to not be verbose
          "quiet"

          # kernel log message level
          "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

          # udev log message level
          "udev.log_level=3"

          # lower the udev log level to show only errors or worse
          "rd.udev.log_level=3"

          # disable systemd status messages
          # rd prefix means systemd-udev will be used instead of initrd
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"

          # disable the cursor in vt to get a black screen during intermissions
          "vt.global_cursor_default=0"
        ];

      lanzaboote = mkIf cfg.boot.secure {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };

      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        generationsDir.copyKernels = true;

        systemd-boot = {
          enable = !cfg.boot.secure;
          configurationLimit = 20;
          editor = false;
        };
      };

      plymouth = {
        enable = cfg.plymouth;
        theme = "${themeCfg.selectedTheme.name}-${themeCfg.selectedTheme.variant}";
        themePackages = [ pkgs.catppuccin-plymouth ];
      };

      tmp = default-attrs {
        useTmpfs = true;
        cleanOnBoot = true;
        tmpfsSize = "50%";
      };
    };

    services.fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };
  };
}
