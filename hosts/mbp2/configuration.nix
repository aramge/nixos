{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
    ../../common/gnome-paperwm.nix
    ../../common/gdrive-mount.nix
    ../../common/syncthing.nix
    ../../common/mail-ramge.nix
    ./wg0.nix
    ./applesmc-next.nix
#    ./fix_broadcom.nix
#    ./bt_dongle.nix
    ./broadcom_off.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.kernelModules = [ "i915" ];
  boot.extraModprobeConfig = ''
    # Magic Mouse: 3-Tasten-Emulation aus, Scrollen an, aber Beschleunigung aus und drosseln
    options hid_magicmouse emulate_3button=0 emulate_scroll_wheel=1 scroll_acceleration=0 scroll_speed=20
    # Bluetooth Alfa Dongle: Autosuspend verbieten gegen Disconnects
    options btusb enable_autosuspend=n
  '';

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    enableRedistributableFirmware = true;
    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver # Für Broadwell und neuer (dein A1502)
        intel-vaapi-driver # Der klassische Treiber als Fallback
        libvdpau-va-gl
      ];
    };
  };

  #  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.cpuFreqGovernor = "schedutil";

  networking = {
    hostName = "mbp2";
    networkmanager.enable = true;
  };

  security.rtkit.enable = true;
  
  services = {
    hardware.bolt.enable = true;
    mbpfan = {
      enable = true;
      settings.general = {
        low_temp = 55;        # Temperatur, bei der die Lüfter spürbar anlaufen
        high_temp = 75;       # Temperatur für stärkeren Lüfter-Einsatz
        max_temp = 88;        # Ab hier drehen die Lüfter auf 100% (Standard ist oft erst bei 85°C)
        polling_interval = 1; # Sensoren jede Sekunde prüfen
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false;
    # Überschreibt ausschließlich die Variante für das MacBook
    xserver.xkb.variant = lib.mkForce "mac_nodeadkeys";
  };

  system.stateVersion = "25.11";
}
