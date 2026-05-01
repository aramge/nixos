{ pkgs, ... }:

{
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "brcm-dongle-firmware";
      src = ./BCM20702A1-0a5c-21e8.hcd;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        # Hier zwingen wir Nix, den Hash aus dem Ziel-Dateinamen zu werfen
        cp $src $out/lib/firmware/brcm/BCM20702A1-0a5c-21e8.hcd
      '';
    })
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", ATTR{idProduct}=="8290", ATTR{authorized}="0"
  '';
}
