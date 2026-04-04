{ config, pkgs, ... }: {
  imports = [ ./ramge.nix ];

  # Einheitliche Zeitzone
  time.timeZone = "Europe/Berlin";
  
  services.gvfs.enable = true;

  # Globale Tastatur-Basiskonfiguration
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys"; # Standard für normale PCs
    options = "ctrl:nocaps";
  };
  console.useXkbConfig = true;

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

  # udisks2 für automatisches/einfaches Mounten aktivieren
  services.udisks2.enable = true;

  # Unterstützung für gängige externe Dateisysteme aktivieren
  boot.supportedFilesystems = [ "ntfs" "exfat" "zfs" ];
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
  
  # Core-Tools für jeden Rechner
  environment.systemPackages = with pkgs; [
    abduco
    bash
    bat
    btop
    exfat    # Für moderne SD-Karten/Sticks (ExFAT)
    fd
    ntfs3g   # Für Windows-Festplatten (NTFS)
    python3
    ripgrep
    sops
    tmux
    usbutils
    vim
    zsh
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  
  services.openssh.enable = true;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  services.blueman.enable = true;
  
  services.emacs = {
    enable = true;
    startWithGraphical = false;
    package = pkgs.emacs-nox;
  };

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
        deviceUri = "ipp://drucker.m.ramge-pm.de/ipp/print";
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "drucker";
  };
}
