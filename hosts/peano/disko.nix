{ ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          EFI = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          lvm = {
            size = "116G";
            content = {
              type = "lvm_pv";
              vg = "vg-peano";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "home";
            };
          };
        };
      };
    };

    lvm_vg."vg-peano" = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "16G";
          content = {
            type = "swap";
          };
        };
        nixos = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };

    zpool.home = {
      type = "zpool";
      options.ashift = "12";
      rootFsOptions = {
        compression = "lz4";
        atime = "off";
        xattr = "sa";
        mountpoint = "none";
      };
      datasets."home/ramge" = {
        type = "zfs_fs";
        options.mountpoint = "legacy";
        mountpoint = "/home";
      };
    };
  };
}
