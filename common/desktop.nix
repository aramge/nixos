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
    ] ++ lib.optionals pkgs.stdenv.isx86_64 [ google-chrome winbox ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  services = {
    emacs = {
      enable = true;
      startWithGraphical = true;
      package = pkgs.emacs;
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
