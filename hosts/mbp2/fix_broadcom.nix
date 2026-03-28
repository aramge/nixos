{ pkgs, lib, ... }:

{
  hardware.firmware = [
    (lib.hiPrio (pkgs.writeTextDir "lib/firmware/brcm/brcmfmac43602-pcie.txt" (builtins.readFile ./brcmfmac43602-pcie.txt)))
  ];
}
