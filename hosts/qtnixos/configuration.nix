{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
  ];

  networking.hostName = "qtnixos";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  sops.defaultSopsFile = ../../secrets/dummy.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  
  sops.secrets.hello = {
    owner = "ramge";
    group = "ramge";
    mode = "0440";
  };

  services.qemuGuest.enable = true;
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    openFirewall = true;
  };

  security.sudo.extraRules = [{
    users = [ "ramge" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  system.stateVersion = "25.11";
}
