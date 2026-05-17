{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/default.nix
      ../../common/desktop.nix
    ];

  networking.hostName = "qnixos";
  networking.hostId = "6120bcb1";
#  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.xkb.options = "caps:ctrl_modifier";

  services.qemuGuest.enable = true;
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xmonad";
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    google-chrome
  ];

  system.stateVersion = "25.11";
}
