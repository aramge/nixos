{ config, lib, pkgs, ... }:

{
  # Stellt sicher, dass mbsync (isync) und secret-tool installiert sind
  environment.systemPackages = with pkgs; [
    isync
    libsecret
  ];

  # Der Timer, der den Takt vorgibt (z. B. 2 Minuten nach Boot, dann alle 5 Minuten)
  systemd.user.timers.mbsync = {
    description = "Timer für mbsync Mail-Synchronisation";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "5m";
      Unit = "mbsync.service";
    };
  };

  # Der eigentliche Service, der ausgeführt wird
  systemd.user.services.mbsync = {
    description = "mbsync Mail-Synchronisation";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync -a";
      # Zwingend nötig, damit secret-tool im Hintergrund mit KeePassXC kommunizieren kann
      Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus";
    };
  };
}
