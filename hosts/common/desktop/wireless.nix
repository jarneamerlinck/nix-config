{
  config,
  ...
}: {

  sops.secrets."wireless/env" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };
  sops.secrets."wireless/home/ssid" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };
  sops.secrets."wireless/home/psk" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };
  sops.secrets."wireless/home-dad/ssid" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };
  sops.secrets."wireless/home-dad/psk" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      
      environmentFiles = [
        config.sops.secrets."wireless/home/ssid".path
        config.sops.secrets."wireless/home/psk".path
        config.sops.secrets."wireless/home-dad/ssid".path
        config.sops.secrets."wireless/home-dad/psk".path
      ];
      profiles = {
        home-dad = {
          connection = {
            id = "home-dad";
            permissions = "";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$HOME_DAD_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_DAD_PASSWORD";
          };
        };
      };

    };
  };
  networking.wireless = {
    enable = false;
    secretsFile = config.sops.secrets."wireless/env".path;
  };
  #
  # # Ensure group exists
  users.groups.network = {};
  #
  # systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
