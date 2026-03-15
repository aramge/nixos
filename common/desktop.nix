{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    xkb = {
      layout = "de";
      variant = "mac_nodeadkeys";
    };
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 144
    '';
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
