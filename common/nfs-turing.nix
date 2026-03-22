{ config, lib, pkgs, ... }:

{
  fileSystems."/mnt/turing/files" = {
    device = "turing:/zroot/data/files";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "nolock" "soft" ];
  };

  fileSystems."/mnt/turing/gh" = {
    device = "turing:/home/ramge/sync/gh";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "nolock" "soft" ];
  };
}
