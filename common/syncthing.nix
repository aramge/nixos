{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "ramge";
    dataDir = "/home/ramge/sync/st";    # Standardverzeichnis für Daten
    configDir = "/home/ramge/.config/syncthing"; # Pfad für die Konfigurationsdateien
    openDefaultPorts = true; # Öffnet automatisch 22000/TCP/UDP und 21027/UDP
  };
}
