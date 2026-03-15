{ pkgs, ... }: {
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
    emacs
    google-chrome
    alsa-utils
  ];
}
