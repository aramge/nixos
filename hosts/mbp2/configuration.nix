{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mbp2";
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };

# Überschreibt ausschließlich die Variante für das MacBook
  services.xserver.xkb.variant = lib.mkForce "mac_nodeadkeys";

  system.stateVersion = "25.11";
}
