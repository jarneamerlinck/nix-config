{
  config,
  ...
}: {

  sops.secrets."wireless/env" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = false;
  };

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      
      environmentFiles = [
        config.sops.secrets."wireless/env".path
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
            psk = "$HOME_DAD_PSK";
          };
        };
      };

    };
  };
  networking.wireless = {
    enable = false;
  };
  #
  # # Ensure group exists
  users.groups.network = {};
  #
  # systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
