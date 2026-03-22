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

  home-manager.users.ramge = { osConfig, config, ... }: 
    let
      dotfiles = "/home/ramge/sync/gh/dotfiles";
      link = config.lib.file.mkOutOfStoreSymlink;
    in {
      home.stateVersion = "25.11";
      
      home.file = {
        ".bashrc".source               = link "${dotfiles}/bash/.bashrc";
        ".bash_profile".source         = link "${dotfiles}/bash/.bash_profile";
        ".gitconfig.local".text = ''
          [user]
          name = ramge@${osConfig.networking.hostName}
        '';
        ".zshenv".source               = link "${dotfiles}/zsh/.zshenv";
  
        ".config/emacs".source         = link "${dotfiles}/emacs/.config/emacs";
        ".config/ghostty".source       = link "${dotfiles}/ghostty/.config/ghostty";
        ".config/git".source           = link "${dotfiles}/git/.config/git";
        ".config/tmux/tmux.conf".source = link "${dotfiles}/tmux/.config/tmux/tmux.conf";
        ".config/picom/picom.conf".source = link "${dotfiles}/tmux/.config/picom/picom.conf";
        ".xmobarrc".source             = link "${dotfiles}/xmobar/.xmobarrc";
        ".config/xmonad".source        = link "${dotfiles}/xmonad/.config/xmonad";
       ".config/zsh".source           = link "${dotfiles}/zsh/.config/zsh";       
      };
    };  
}
