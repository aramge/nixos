{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
  ];

  networking.hostName = "n100-nixos";
  networking.networkmanager.enable = true;
  networking.interfaces.enp2s0.macAddress = "a8:b8:e0:04:46:36";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" ];

  services.xserver.xkb = {
    layout = "de";
    variant = pkgs.lib.mkForce "nodeadkeys";
    options = "altwin:swap_lalt_lwin,caps:ctrl_modifier";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";

  system.stateVersion = "25.11";
}
