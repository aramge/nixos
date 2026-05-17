{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../common/default.nix
    ../../common/desktop.nix
    ../../common/gnome-paperwm.nix
    ../../common/daskeyboard.nix
  ];

  # --- Bootloader & Dateisysteme ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  zramSwap.enable = true;

  # --- Netzwerk ---
  networking.hostName = "peano";
  networking.hostId = "8f3c7b2a";
  networking.networkmanager.enable = true;

  # --- Audio (Pipewire statt Pulseaudio) ---
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- Virtualisierung ---
  virtualisation.docker.enable = true;

  # --- Benutzerverwaltung ---
  # Initialpasswort - nach erster Anmeldung ändern mit: passwd
  users.users.ramge.initialPassword = "ramge";

  # --- Home Manager ---
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";

  # --- System ---
  system.stateVersion = "25.11";
}
