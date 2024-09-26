{
  config,
  disks ? [ "/dev/nvme0n1" ],
  ...
}:
let
  defaultBtrfsOpts = [
    "defaults"
    "compress=zstd:1"
    "ssd"
    "noatime"
    "nodiratime"
  ];
in
{
  disko.devices = {
    disk = {
      nvme0 = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = {
            EFI = {
              priority = 1;
              name = "EFI";
              start = "0%";
              end = "1024MiB";
              bootable = true;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "NixOS";
              end = "-16G";
              content = {
                type = "btrfs";
                name = "NixOS";
                extraOpenArgs = [ "--allow-discards" ];

                content = {
                  type = "btrfs";
                  # Override existing partition
                  extraArgs = [ "-f" ];

                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@games" = {
                      mountpoint = "/mnt/games";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@kvm" = {
                      mountpoint = "/mnt/kvm";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@steam" = {
                      mountpoint = "/mnt/steam";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@userdata/@documents" = {
                      mountpoint = "/home/${config.snowfallorg.users.name}/Documents";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@userdata/@downloads" = {
                      mountpoint = "/home/${config.snowfallorg.users.name}/Downloads";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@userdata/@music" = {
                      mountpoint = "/home/${config.snowfallorg.users.name}/Music";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@userdata/@pictures" = {
                      mountpoint = "/home/${config.snowfallorg.users.name}/Pictures";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@userdata/@videos" = {
                      mountpoint = "/home/${config.snowfallorg.users.name}/Videos";
                      mountOptions = defaultBtrfsOpts;
                    };
                  };
                };
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true; # resume from hiberation from this device
              };
            };
          };
        };
      };
    };
  };
}
