{ config, lib, pkgs, ... }:

{
  sops.secrets."rclone-config" = {
    sopsFile = ../secrets/rclone.yaml;
    owner = "ramge";
  };

  systemd.user.services.rclone-gd = {
    description = "Rclone mount for Google Drive (gd)";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.rclone "/run/wrappers" ];
    
    serviceConfig = {
      Type = "notify";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p %h/sync/gd %h/.config/rclone"
        "${pkgs.coreutils}/bin/cp -f ${config.sops.secrets."rclone-config".path} %h/.config/rclone/rclone.conf"
        "${pkgs.coreutils}/bin/chmod 600 %h/.config/rclone/rclone.conf"
      ];
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gd: %h/sync/gd \
          --config %h/.config/rclone/rclone.conf \
          --vfs-cache-mode writes \
          --dir-cache-time 1h \
          --log-level INFO
      '';
      ExecStop = "/run/wrappers/bin/fusermount3 -u %h/sync/gd";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
