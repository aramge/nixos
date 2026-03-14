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

  home-manager.users.ramge = { osConfig, config, ... }: {
    home.stateVersion = "25.11";
    home.packages = with pkgs; [ tmux zsh emacs ghostty git ];
    home.file = {
      ".zshenv".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/zsh/.zshenv";
      ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/zsh/.config/zsh";
      ".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/tmux/.config/tmux/tmux.conf";
      ".config/emacs".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/emacs/.config/emacs";
      ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/ghostty/.config/ghostty";
      ".config/git".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/git/.config/git";
      ".gitconfig.local".text = ''
        [user]
        name = ramge@${osConfig.networking.hostName}
      '';
    };
  };

  system.stateVersion = "25.11";
}
