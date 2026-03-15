{ config, pkgs, ... }: {
  imports = [ ./ramge.nix ];

  # Einheitliche Zeitzone
  time.timeZone = "Europe/Berlin";

  # Standard-Spracheinstellungen
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
      LC_TIME = "en_DK.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
    ];
  };

  # Flakes aktivieren und proprietäre Software erlauben
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Core-Tools für jeden Rechner
  environment.systemPackages = with pkgs; [
    tmux stow zsh bash python3 vim
    texlive.combined.scheme-medium
  ];

  services.openssh.enable = true;
  programs.zsh.enable = true;

  # Avahi für die Auflösung von .local-Adressen (z. B. drucker.local)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Druckdienst systemweit für alle Rechner aktivieren
  services.printing.enable = true;

  hardware.printers = {
    ensurePrinters = [
      {
        name = "drucker";
        deviceUri = "ipp://drucker.local/ipp/print";
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "drucker";
  };
}
