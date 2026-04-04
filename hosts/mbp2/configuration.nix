{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
    ../../common/gdrive-mount.nix
    ../../common/syncthing.nix
    ./fix_broadcom.nix
    ./wg0.nix
    ./applesmc-next.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.mbpfan = {
    enable = true;
    settings.general = {
      low_temp = 55;        # Temperatur, bei der die Lüfter spürbar anlaufen
      high_temp = 75;       # Temperatur für stärkeren Lüfter-Einsatz
      max_temp = 88;        # Ab hier drehen die Lüfter auf 100% (Standard ist oft erst bei 85°C)
      polling_interval = 1; # Sensoren jede Sekunde prüfen
    };
  };
  
#  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.cpuFreqGovernor = "schedutil";
  
  networking.hostName = "mbp2";
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true; # Ignoriert das Touchpad komplett, solange du tippst
      accelSpeed = "-0.3";       # Drosselt die Grundnervosität (Werte von "-1.0" bis "1.0", Standard ist "0")
      
      # Falls dir bloßes Berühren (Tap-to-click) generell zu empfindlich ist:
      # tapping = false; # Auskommentieren, wenn du physisch drücken willst
    };
  };

  # Überschreibt ausschließlich die Variante für das MacBook
  services.xserver.xkb.variant = lib.mkForce "mac_nodeadkeys";


  # Spezifische Treiber für Intel Iris (A1502)
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver # Für Broadwell und neuer (dein A1502)
    intel-vaapi-driver # Der klassische Treiber als Fallback
    libvdpau-va-gl
  ];

  services.hardware.bolt.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
    
  system.stateVersion = "25.11";
}
