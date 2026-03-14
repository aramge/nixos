{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    xkb = {
      layout = "de";
      variant = "mac_nodeadkeys";
    };
    # Setzt die DPI für scharfe Skalierung auf 4K Monitoren
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 144
    '';
  };
  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    emacs
    google-chrome
  ];
}
