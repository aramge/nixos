{ config, pkgs, ... }:

{
  imports = [ ../users/ramge/nixos.nix ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_6_19;
    supportedFilesystems = [ "ntfs" "exfat" "zfs" ];
  };

  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);

  time.timeZone = "Europe/Berlin";
  # time.timeZone = "Africa/Dar_es_Salaam";

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

  console.useXkbConfig = true;

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    printing.enable = true;
    
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    
    xserver.xkb = {
      layout = "de";
      variant = "nodeadkeys";
      options = "ctrl:nocaps";
    };
  };

  environment.systemPackages = with pkgs; [
    abduco
    bash
    bat
    btop
    exfat # Für moderne SD-Karten/Sticks (ExFAT)
    fd
    git
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US-large
    hyphenDicts.de_DE
    hyphenDicts.en_US
    ntfs3g # Für Windows-Festplatten (NTFS)
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
