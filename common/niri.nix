{ pkgs, ... }:

{
  programs.niri.enable = true;

  services = {
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
}
