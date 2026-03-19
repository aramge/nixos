{ config, pkgs, ... }: {
  users.groups.ramge = {
    gid = 1001;
  };

  users.users.ramge = {
    isNormalUser = true;
    uid = 1001;
    group = "ramge";
    description = "Axel Ramge";
    extraGroups = [ "networkmanager" "wheel" "docker" "users" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8q7f2ZLoCoSgmwoP6FjzJF23c1QHI36CO8oSrJMDxd ansible"
    ];
  };

  security.sudo.extraRules = [{
    users = [ "ramge" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/github_ed25519
  '';

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "ramge@${config.networking.hostName}";
        email = "axel@ramge.de";
      };
    };
  };

  home-manager.users.ramge = { osConfig, config, ... }: {
    home.stateVersion = "25.11";
    home.packages = with pkgs; [ tmux zsh bash emacs ghostty git rofi ];
    home.file = {
      ".bashrc".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/bash/.bashrc";
      ".bash_profile".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/bash/.bash_profile";
      ".zshenv".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/zsh/.zshenv";
      ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/zsh/.config/zsh";
      ".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/tmux/.config/tmux/tmux.conf";
      ".config/emacs".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/emacs/.config/emacs";
      ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/ghostty/.config/ghostty";
      ".config/xmonad".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/xmonad/.config/xmonad";
      ".config/git".source = config.lib.file.mkOutOfStoreSymlink "/home/ramge/sync/gh/dotfiles/git/.config/git";
      ".gitconfig.local".text = ''
        [user]
        name = ramge@${osConfig.networking.hostName}
      '';
    };
  };
}
