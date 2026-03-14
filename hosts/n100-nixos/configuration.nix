{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/default.nix
    ../../common/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" ];

  networking.hostName = "n100-nixos";
  networking.networkmanager.enable = true;
  networking.interfaces.enp2s0.macAddress = "a8:b8:e0:04:46:36";

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

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  services.xserver.xkb.options = "altwin:swap_lalt_lwin,caps:ctrl_modifier";
  services.xserver.xkb.variant = pkgs.lib.mkForce "nodeadkeys";

  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
