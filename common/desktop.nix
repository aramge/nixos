{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    dpi = 192;
    displayManager.lightdm.enable = true;
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    xkb = {
      layout = "de";
      variant = "nodeadkeys";
      model = "pc105";
    };
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
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
      ''
    )
    alsa-utils
    emacs
    freecad
    fzf
    ghostty
    gimp
    gmrun
    gnucash
    inkscape
    keepassxc
    libreoffice
    maim
    mediathekview
    pulseaudio
    remmina
    rofi
    texlive.combined.scheme-full
    tigervnc 
    vlc
    wasistlos
    xclip
    xmobar
  ] ++ lib.optionals stdenv.isx86_64 [
      google-chrome
      winbox
  ] ++ lib.optionals stdenv.isAarch64 [
      chromium
  ];
}
