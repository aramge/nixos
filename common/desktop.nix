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
    WIDTH=$(${xlibs.xrandr}/bin/xrandr | ${gnugrep}/bin/grep "Virtual-1 connected" | ${gnugrep}/bin/grep -oP '\d+(?=x)')

    if [ "$WIDTH" -eq 3024 ]; then
        echo "Xft.dpi: 172" | ${xlibs.xrdb}/bin/xrdb -merge
    elif [ "$WIDTH" -eq 2560 ]; then
        echo "Xft.dpi: 109" | ${xlibs.xrdb}/bin/xrdb -merge
    else
        echo "Xft.dpi: 96" | ${xlibs.xrdb}/bin/xrdb -merge
    fi
  '')
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
