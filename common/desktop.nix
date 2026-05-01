{ pkgs, lib, ... }:

{
  # Niri als Compositor direkt hier aktivieren
  programs.niri.enable = true;

  hardware.graphics.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    
    systemPackages = with pkgs; [
      adwaita-icon-theme
      alsa-utils
      chromium
      darktable
      dbeaver-bin
      foot
      freecad
      fzf
      ghostty
      gimp
      gnucash
      grim
      inkscape
      keepassxc
      kitty
      libinput-gestures
      libreoffice
      mediathekview
      networkmanagerapplet
      pavucontrol
      pulseaudio
      rclone
      remmina
      rofi
      slurp
      sqlite
      texlive.combined.scheme-full
      tigervnc
      vlc
      wasistlos
      wl-clipboard
      wtype
    ] ++ lib.optionals pkgs.stdenv.isx86_64 [ google-chrome winbox4 ];
  };

  fonts.packages = with pkgs; [
    # Der Goldstandard für das Terminal und alle Icons in Niri/Waybar
    nerd-fonts.jetbrains-mono
    
    # Das Sicherheitsnetz: Deckt praktisch alle Sprachen und Zeichen der Welt ab
    noto-fonts
    noto-fonts-cjk-sans # Für asiatische Schriftzeichen
    noto-fonts-color-emoji    # Saubere Emojis für Chat und Web

    # Die Klassiker: Arial, Times New Roman, Verdana (verhindert kaputte Webseiten)
    corefonts 
  ];

  # Macht die Schriften für das System und Wayland-Apps sauber verfügbar
  fonts.fontconfig.enable = true;

  services = {
    emacs = {
      enable = true;
      startWithGraphical = true;
      package = pkgs.emacs-pgtk;
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.niri}/bin/niri-session";
          user = "greeter";
        };
      };
    };
  };

  programs.dconf.enable = true;
  
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
