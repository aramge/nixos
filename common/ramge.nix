{ pkgs, ... }: {
  # Die Gruppe explizit definieren
  users.groups.ramge = {
    gid = 1001;
  };

  users.users.ramge = {
    isNormalUser = true;
    uid = 1001;
    group = "ramge"; # Primäre Gruppe
    description = "Axel Ramge";
    extraGroups = [ "networkmanager" "wheel" "docker" "users" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8q7f2ZLoCoSgmwoP6FjzJF23c1QHI36CO8oSrJMDxd ansible"
    ];
  };

  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/github_ed25519
  '';
}
