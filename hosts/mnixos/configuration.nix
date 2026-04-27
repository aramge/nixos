{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
    ../../common/niri.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "mnixos";
    networkmanager.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  security.rtkit.enable = true;

  services = {
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };
    xserver.xkb = lib.mkForce { layout = "de"; variant = "mac_nodeadkeys"; };
    udev.extraHwdb = ''
      evdev:input:b*v*p*e*
       KEYBOARD_KEY_70035=102nd
       KEYBOARD_KEY_70064=grave
    '';
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
    pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };
  };

  # UTM Shared Folder
  fileSystems."/mnt/mac-share" = {
    device = "share";
    fsType = "9p";
    options = [ 
      "trans=virtio" 
      "version=9p2000.L" 
      "msize=1048576" 
      "nofail" 
      "x-systemd.automount" 
      "noauto" 
      "access=any"
    ];
  };
  
  systemd.tmpfiles.rules = [ "L+ /home/ramge/sync - - - - /mnt/mac-share" ];
  
  environment.systemPackages = with pkgs; [ brightnessctl spice-vdagent ];

  # Host-spezifische User-Rechte (wichtig für Grafik-Zugriff in der VM)
  users.users.ramge.extraGroups = [ "networkmanager" "video" "render" "docker" ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.ramge = import ../../users/ramge/home.nix;
  };

  system.stateVersion = "25.11";
}
