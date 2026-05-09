{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
    ../../common/gnome-paperwm.nix
  ];

  # --- Boot & Kernel ---
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelParams = [ "video=Virtual-1:2560x1440@60" ];

  # --- Hardware & Netzwerk ---
  hardware.enableRedistributableFirmware = true;
  hardware.pulseaudio.enable = false;
  networking = {
    hostName = "mnixos";
    networkmanager.enable = true;
  };

  # --- System-Dienste & VM-Integration ---
  security.rtkit.enable = true;
  virtualisation.docker.enable = true;
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver.xkb = lib.mkForce { layout = "de"; variant = "mac_nodeadkeys"; };
    udev.extraHwdb = ''
      evdev:input:b*v*p*e*
        KEYBOARD_KEY_70035=102nd
        KEYBOARD_KEY_70064=grave
    '';
  };

  # --- UTM Shared Folder (9p -> Bindfs) ---
  fileSystems."/mnt/mac-share-raw" = {
    device = "share";
    fsType = "9p";
    options = [ "trans=virtio" "version=9p2000.L" "msize=1048576" "nofail" ];
  };
  fileSystems."/mnt/mac-share" = {
    device = "/mnt/mac-share-raw";
    fsType = "fuse.bindfs";
    depends = [ "/mnt/mac-share-raw" ];
    options = [
      "force-user=ramge"
      "force-group=users"
      "create-for-user=501"
      "allow_other"
      "nofail"
    ];
  };
  systemd.tmpfiles.rules = [ "L+ /home/ramge/sync - - - - /mnt/mac-share" ];

  # --- Pakete & User ---
  environment.systemPackages = with pkgs; [ brightnessctl spice-vdagent ];
  users.users.ramge.initialPassword = "ramge";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";

  system.stateVersion = "25.11";
}
