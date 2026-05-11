{ ... }:

{
  # DAS KEYBOARD: physisch vertauschte Tasten AltL <-> SuperL + CapsLock als Ctrl
  services.xserver.xkb.options = "altwin:swap_lalt_lwin,caps:ctrl_modifier";
  console.useXkbConfig = true;

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "altwin:swap_lalt_lwin" "caps:ctrl_modifier" ];
      };
    };
  }];
}
