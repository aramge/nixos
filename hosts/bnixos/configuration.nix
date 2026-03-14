{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" ];

  networking.hostName = "bnixos";
  networking.networkmanager.enable = true;

  console.keyMap = "de";

  security.sudo.extraRules = [
    {
      users = [ "ramge" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    emacs-nox
  ];

  system.stateVersion = "25.11";
}
