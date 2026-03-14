{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop-base.nix
    ../../common/desktop-xfce.nix
  ];

  networking.hostName = "n100-nixos";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    openFirewall = true;
  };

  security.sudo.extraRules = [{
    users = [ "ramge" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";

  system.stateVersion = "25.11";
}
