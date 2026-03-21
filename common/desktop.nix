{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    dpi = 120;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    xkb = {
      layout = "de";
      variant = "mac_nodeadkeys";
    };
  };
  
  console.useXkbConfig = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    emacs
    freecad
    fzf
    ghostty
    ghostty
    gimp
    gmrun
    gnucash
    inkscape
    keepassxc
    libreoffice
    maim
    mediathekview
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
