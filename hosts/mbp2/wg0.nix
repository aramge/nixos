# hosts/mbp2/wg0.nix
{ config, ... }:

{
  sops.secrets.wg_private_key = {
    # Achtung: Pfad relativ zur wg0.nix anpassen!
    sopsFile = ../../secrets/mbp2.yaml; 
    owner = "root";
  };

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    address = [ "10.200.200.12/32" ];
    dns = [ "172.19.10.32" ];
    
    privateKeyFile = config.sops.secrets.wg_private_key.path;

    peers = [
      {
        publicKey = "xOp+EPQtin/UaiX+3gjkFzB2MzBTkST5OVnmFEix8ng=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "pub.ramge-pm.de:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
