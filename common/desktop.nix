{ pkgs, lib, ... }: {
  hardware.graphics.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # Diese beiden Zeilen sind der Retter für UTM ohne Hardware-GL:
      WLR_RENDERER = "pixman";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      adwaita-icon-theme alsa-utils chromium darktable dbeaver-bin
      freecad fzf foot ghostty gimp gnucash inkscape keepassxc kitty
      libinput-gestures libreoffice mediathekview networkmanagerapplet
      pavucontrol pulseaudio rclone remmina rofi sqlite
      texlive.combined.scheme-full tigervnc vlc wasistlos wtype
      wl-clipboard grim slurp
    ] ++ lib.optionals stdenv.isx86_64 [ google-chrome winbox ]
      ++ lib.optionals stdenv.isAarch64 [ chromium ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono noto-fonts noto-fonts-color-emoji
  ];

  services = {
    blueman.enable = true;
    emacs = { enable = true; startWithGraphical = true; package = pkgs.emacs; };
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
