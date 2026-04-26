{ config, pkgs, ... }: {
  imports = [ ./ramge.nix ];

  # Einheitliche Zeitzone
  time.timeZone = "Europe/Berlin";
#   time.timeZone = "Africa/Dar_es_Salaam";
  
  services = {
    gvfs.enable = true;
    xserver.xkb = {               # Globale Tastatur-Basiskonfiguration
        layout = "de";
        variant = "nodeadkeys";              # Standard für normale PCs
        options = "ctrl:nocaps";
    };
    # udisks2 für automatisches/einfaches Mounten aktivieren
    udisks2.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    # Druckdienst systemweit für alle Rechner aktivieren
    printing.enable = true;
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
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US-large
    hyphenDicts.de_DE
    hyphenDicts.en_US
    ntfs3g   # Für Windows-Festplatten (NTFS)
    python3
    ripgrep
    sops
    tmux
    unzip
    usbutils
    vim
    zip
    zsh
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];



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
