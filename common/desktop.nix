{ pkgs, lib, ... }: {

  nixpkgs.config.permittedInsecurePackages = [
      "electron-38.8.4"
  ];
  
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; [
      # Datenbank-Tools
      dbeaver-bin
      sqlite

      # RStudio als Wrapper, der die CRAN-Pakete direkt mitbringt
      (rstudioWrapper.override {
        packages = with rPackages; [
          # Hier trägst du deine gewünschten CRAN-Pakete ein, z. B.:
          dplyr
          ggplot2
          DBI
          RSQLite
        ];
      })

      (writeShellScriptBin "fix-dpi" ''
        # Pfade explizit über Nix-Store auflösen
        XRANDR="${xorg.xrandr}/bin/xrandr"
        XRDB="${xorg.xrdb}/bin/xrdb"
        GREP="${gnugrep}/bin/grep"

        WIDTH=$($XRANDR | $GREP "Virtual-1 connected" | $GREP -oP '\d+(?=x)')

        if [ "$WIDTH" -eq 3024 ]; then
          # MacBook Pro 14"
          echo "Xft.dpi: 172" | $XRDB -merge
        elif [ "$WIDTH" -eq 2560 ]; then
          # LG 27"
          echo "Xft.dpi: 109" | $XRDB -merge
        else
          # Fallback
          echo "Xft.dpi: 96" | $XRDB -merge
        fi
      '')
      adwaita-icon-theme
      alsa-utils
      chromium
      darktable
      freecad
      fzf
      ghostty
      gimp
      gmrun
      gnomeExtensions.forge
      gnomeExtensions.blur-my-shell
      gnome-tweaks
      gnucash
      inkscape
      keepassxc
      kitty
      libinput-gestures
      libreoffice
      maim
      mediathekview
      networkmanagerapplet
      pavucontrol
      pulseaudio
      rclone
      remmina
      rofi
      texlive.combined.scheme-full
      tigervnc
      vlc
      wasistlos
      wtype
      xclip
      xdg-user-dirs
      xmobar

      # --- Dual-Use & Wayland Tools ---
      wl-clipboard  # Wayland-Alternative zu xclip
      grim          # Wayland-Alternative zu maim (Screenshots)
      slurp         # Wayland-Auswahlwerkzeug (für grim)
    ] ++ lib.optionals stdenv.isx86_64 [
      google-chrome
      winbox
    ] ++ lib.optionals stdenv.isAarch64 [
      chromium
    ];
  };

  fonts = {
    packages = with pkgs; [
      # Nur das spezifische Set installieren (spart Platz und Zeit)
      nerd-fonts.jetbrains-mono

      # Für allgemeine Emojis und Fallbacks
      noto-fonts
      noto-fonts-color-emoji
    ];
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true; # Wichtig für einige ältere Apps/Steam
    };
  };

  programs = {
    hyprland.enable = true; # Hyprland nativ aktivieren (baut die Session für LightDM)
    nm-applet.enable = true;
    waybar.enable = true;
  };

  services = {
    blueman.enable = true;
    emacs = {
      enable = true;
      startWithGraphical = true;
      package = pkgs.emacs;
    };
    xserver = {
      enable = true;
      dpi = 192;
#      displayManager.lightdm.enable = false;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
#      windowManager.xmonad = {
#        enable = true;
#        enableContribAndExtras = true;
#      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
