{ pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  ##
  # Desktop VM config
  ##
  boot = {
    blacklistedKernelModules = [ "eeepc_wmi" ];

    # consoleLogLevel = 0;

    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl."kernel.sysrq" = 1;
    kernelParams = [
      "video=DP-2:1920x1080@75"
      "video=DP-3:1920x1080@75"
    ];

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
      # verbose = false;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "ssd"
        "subvol=/@"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [
        "fmask=0137"
        "dmask=0027"
      ];
    };

    "/home/peario/Downloads" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@userdata/@downloads"
      ];
    };

    "/home/peario/Documents" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@userdata/@documents"
      ];
    };

    "/home/peario/Pictures" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@userdata/@pictures"
      ];
    };

    "/home/peario/Videos" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@userdata/@videos"
      ];
    };

    "/home/peario/Music" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@userdata/@music"
      ];
    };

    "/mnt/kvm" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "nodatacow"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@kvm"
      ];
    };

    "/mnt/games" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "nodatacow"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@games"
      ];
    };

    "/mnt/steam" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "rw"
        "nodatacow"
        "noatime"
        "compress-force=zstd:1"
        "ssd"
        "subvol=/@steam"
      ];
    };
  };

  # FIX: Figure out the real value of this
  # swapDevices = [{ device = "/dev/disk/by-uuid/be1e6602-df3a-4d27-9d46-c52586093cb8"; }];

  hardware = {
    enableRedistributableFirmware = true;
  };
}
