# Hardware-Konfiguration für peano (i5-9600K, nvme0n1: 512M EFI + LVM vg-peano + ZFS home)
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-mod" "usb_storage" "uas" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # LVM aktivieren — NUR vg-peano, fremde VGs ignorieren
  boot.initrd.services.lvm.enable = true;
  boot.initrd.systemd.contents."/etc/lvm/lvmlocal.conf".text = ''
    activation {
      auto_activation_volume_list = [ "vg-peano" ]
    }
  '';
  environment.etc."lvm/lvmlocal.conf".text = ''
    activation {
      auto_activation_volume_list = [ "vg-peano" ]
    }
  '';

  fileSystems."/" = {
    device = "/dev/vg-peano/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/02C7-5F39";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # ZFS: nur eigenen Pool importieren, keine fremden Pools
  boot.zfs.forceImportRoot = false;
  boot.zfs.devNodes = "/dev/disk/by-id";

  fileSystems."/home" = {
    device = "home/ramge";
    fsType = "zfs";
  };

  swapDevices = [
    { device = "/dev/vg-peano/swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
