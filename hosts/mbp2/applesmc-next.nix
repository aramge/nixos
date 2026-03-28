{ config, pkgs, lib, ... }:

let
  applesmc-next = config.boot.kernelPackages.callPackage ({ kernel, stdenv, lib, fetchFromGitHub }:
    stdenv.mkDerivation rec {
      pname = "applesmc-next";
      version = "master";

      src = fetchFromGitHub {
        owner = "c---";
        repo = "applesmc-next";
        rev = "c125e50911053a0595fe56f48da3874587c59d46";
        hash = "sha256-eXGs/5JZo5BIJtPUg++xaggSFkxyGXCUiDtgoj1tSuw=";
      };

      nativeBuildInputs = kernel.moduleBuildDependencies;

      # Kbuild direkt ansteuern, Makefile des Repos ignorieren
      buildPhase = ''
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
      '';

      installPhase = ''
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) INSTALL_MOD_PATH=$out modules_install
      '';

      meta = with lib; {
        description = "AppleSMC kernel module with battery charge thresholds";
        license = licenses.gpl2Only;
        platforms = platforms.linux;
      };
    }
  ) {};
in
{
  boot.extraModulePackages = [ applesmc-next ];
  boot.kernelModules = [ "applesmc" ];

  systemd.services.battery-charge-limit = {
    description = "Setze Akku-Ladegrenze auf 80%";
    wantedBy = [ "multi-user.target" ];
    after = [ "sysinit.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold || true'";
      RemainAfterExit = "yes";
    };
  };
}
