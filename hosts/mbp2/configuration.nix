{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../common/default.nix
    ../../common/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=1
  '';

  networking.hostName = "mbp2";
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;
  services.libinput.touchpad.tapping = true;
  services.libinput.touchpad.clickMethod = "clickfinger";
  services.libinput.touchpad.disableWhileTyping = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    xfce.xfce4-pulseaudio-plugin
  ];

  system.stateVersion = "25.11";
}
