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

  services.picom.enable = true;
  
  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
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
