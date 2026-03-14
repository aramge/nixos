{ config, pkgs, ... }: {
  imports = [ ./ramge.nix ];

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "en_DK.UTF-8"; # Der ISO-Goldstandard
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8" # Jetzt als English-Denmark
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    tmux stow zsh python3 vim
  ];

  services.openssh.enable = true;
  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "ramge@${config.networking.hostName}";
        email = "axel@ramge.de";
      };
    };
  };
}
