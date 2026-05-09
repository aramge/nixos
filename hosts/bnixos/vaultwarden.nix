{ config, pkgs, ... }:

{
  sops.secrets.hetzner-api-key = {
    sopsFile = ../../secrets/bnixos.yaml;
    owner = "acme";
    group = "acme";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "axel@ramge.de";
    certs."ramge-pm.de" = {
      domain = "*.ramge-pm.de";
      extraDomainNames = [ "ramge-pm.de" ];
      dnsProvider = "hetzner";
      credentialFiles = {
        "HETZNER_API_TOKEN_FILE" = config.sops.secrets.hetzner-api-key.path;
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DATA_FOLDER = "/var/lib/vaultwarden";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://vv.m.ramge-pm.de";
      SIGNUPS_ALLOWED = true; # nach erster Registrierung auf false setzen
      LOG_LEVEL = "warn";
    };
  };

  # Vaultwarden soll auf dem gemounteten Disk-Volume laufen
  systemd.services.vaultwarden = {
    after = [ "var-lib-vaultwarden.mount" ];
    requires = [ "var-lib-vaultwarden.mount" ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."vv.m.ramge-pm.de" = {
      serverAliases = [ "vv" ];
      forceSSL = true;
      useACMEHost = "ramge-pm.de";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
        proxyWebsockets = true;
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
