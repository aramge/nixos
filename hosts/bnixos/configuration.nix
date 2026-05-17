{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vaultwarden.nix
    ../../common/default.nix # Hierüber kommt die ramge.nix mit Sudo-Regeln und User-Settings
    ../../common/monitor.nix
  ];

  # Bootloader-Konfiguration für EFI-Systeme
  boot.loader.systemd-boot.enable = true;
  
  # Kernel-Parameter, wichtig für die serielle Konsole im Headless-Betrieb
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" ];

  # Netzwerkkonfiguration
  networking.hostName = "bnixos";
  networking.hostId = "43f9c1a3";
  networking.networkmanager.enable = true;

  # Klassische Tastaturbelegung für die Textkonsole (da kein X-Server existiert)

  # Docker-Aktivierung für Container-Workloads
  virtualisation.docker.enable = true;

  # Server-spezifische Pakete (Emacs ohne X11-Abhängigkeiten)
  environment.systemPackages = with pkgs; [
    emacs-nox
  ];

  # NixOS Release-Version (nicht ändern, außer bei Neuinstallationen)
  system.stateVersion = "25.11";
}
