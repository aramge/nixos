# Hardware-Konfiguration für peano (i5-9600K, NVMe, Root-on-ZFS via Disko)
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "usb_storage" "uas" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # --- Hinweis ---
  # Dateisysteme (ZFS) und Swap werden nun vollständig und unsichtbar über disko.nix generiert.
  # Bootloader, Host-ID und ZRAM sind sauber in die configuration.nix ausgelagert.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
