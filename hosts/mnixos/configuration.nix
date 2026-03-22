{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mnixos";
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };

  # Spezifischer Fix für den UTM/Apple Digitizer
  services.xserver.inputClassSections = [
    ''
      Identifier "UTM Digitizer Scroll Fix"
      MatchProduct "Apple Inc. Virtual USB Digitizer"
      Driver "libinput"
      Option "NaturalScrolling" "true"
      Option "ScrollMethod" "twofinger"
      Option "HorizontalScrolling" "true"
    ''
  ];

  services.xserver.xkb = lib.mkForce {
    layout = "de";
    variant = "mac_nodeadkeys";
  };
  
  # Workaround für den AVF ISO-Bug (< und ^ vertauscht)
  services.udev.extraHwdb = ''
    evdev:input:b*v*p*e*
     KEYBOARD_KEY_70035=102nd
     KEYBOARD_KEY_70064=grave
  '';

  services.xserver.displayManager.sessionCommands = ''
    xrandr --output Virtual-1 --mode 2560x1440
    echo "Xft.dpi: 192" | xrdb -merge
  '';

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    spice-vdagent
    xfce.xfce4-pulseaudio-plugin
  ];

  system.stateVersion = "25.11";
}
