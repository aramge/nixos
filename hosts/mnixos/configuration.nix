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

  boot.kernelParams = [ "video=Virtual-1:2560x1440@60" ];

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
  # 1. Der rohe, versteckte Mount-Punkt
  fileSystems."/mnt/mac-share-raw" = {
    device = "share";
    fsType = "9p";
    options = [ "trans=virtio" "version=9p2000.L" "msize=1048576" "nofail" ];
  };

  # 2. Die Übersetzer-Schicht für deinen User
  fileSystems."/mnt/mac-share" = {
    device = "/mnt/mac-share-raw";
    fsType = "fuse.bindfs";
    depends = [ "/mnt/mac-share-raw" ];
    options = [ 
      "force-user=ramge"        # In der VM gehört alles dir
      "force-group=users"
      "create-for-user=501"     # Neue Dateien bekommen auf dem Mac die 501
      "create-for-group=20"     # 20 ist die Standard 'staff'-Gruppe auf macOS
      "allow_other"             # Erlaubt dem Root-User (für Rebuilds) den Zugriff
      "nofail" 
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
