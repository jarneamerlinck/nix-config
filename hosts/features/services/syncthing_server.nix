{ config, ... }:
{
  sops.secrets."syncthing/key.pem" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = false;
    owner = config.users.users.eragon.name;
    mode = "0400";
  };

  sops.secrets."syncthing/cert.pem" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = false;
    owner = config.users.users.eragon.name;
    mode = "0400";
  };

  sops.secrets."syncthing/gui" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = false;
    owner = config.users.users.eragon.name;
    mode = "0440";
  };
  networking.firewall.allowedTCPPorts = [ 8384 ];
  services.syncthing = {
    # Ports
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    guiPasswordFile = config.sops.secrets."syncthing/gui".path;
    configDir = "/data/sync/config";
    dataDir = "/data/sync";

    # Credentials
    user = "eragon";
    group = "users";
    key = config.sops.secrets."syncthing/key.pem".path;
    cert = config.sops.secrets."syncthing/cert.pem".path;
    settings = {
      options = {
        urAccepted = -1;
      };
      devices = {
        pulsar = {
          name = "pulsar";
          id = "36EWD2I-Y7XD4GW-AHMB3OE-MV7I573-XKYYDDJ-2GFB367-B2AP3PV-VKDVOQC";
          autoAcceptFolders = true;
        };

      };
      folders = {
        vaults = {
          enable = true;
          id = "vaults";
          path = "/data/sync/vaults";
          type = "sendreceive";
          versioning.type = "staggered";
          devices = [ "pulsar" ];
        };
      };
    };
  };
}
