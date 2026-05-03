{ ... }:

{
  # Zieht dem internen Broadcom-WLAN (PCIe) den Stecker
  boot.blacklistedKernelModules = [ "brcmfmac" "brcmutil" ];

  # Zieht dem internen Broadcom-Bluetooth (USB) den Stecker
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", ATTR{idProduct}=="8290", ATTR{authorized}="0"
  '';
}
