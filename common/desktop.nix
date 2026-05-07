{ pkgs, lib, ... }:

{
  hardware.graphics.enable = true;
  programs.dconf.enable = true;

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
#      networkmanagerapplet
      pavucontrol
#      pulseaudio
      rclone
      remmina
      rofi
      slurp
      sqlite
      texlive.combined.scheme-full
      thunderbird
      tigervnc
      vlc
      wasistlos
      wl-clipboard
      wtype
    ] ++ lib.optionals pkgs.stdenv.isx86_64 [ google-chrome winbox4 ];
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      corefonts 
    ];
  };

  services = {
    emacs = {
      enable = true;
      startWithGraphical = true;
      package = pkgs.emacs-pgtk;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
