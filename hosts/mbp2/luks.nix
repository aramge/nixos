{
  boot.initrd.luks.devices."cryptpool" = {
    device = "/dev/sda2";
    preLVM = true;
  };
}
