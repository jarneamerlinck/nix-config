{ config, ... }:
{

  sops.secrets."wireless/env" = {
    sopsFile = ../../base/users/eragon/secrets.yml;
    neededForUsers = false;
  };

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {

      environmentFiles = [ config.sops.secrets."wireless/env".path ];
      profiles = {
        home-wifi = {
          connection = {
            id = "home-wifi";
            permissions = "";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$HOME_WIFI_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_WIFI_PSK";
          };
        };
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

        home-mep = {
          connection = {
            id = "home-mep";
            permissions = "";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$HOME_MEP_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_MEP_PSK";
          };
        };

        hotspot = {
          connection = {
            id = "hotspot";
            permissions = "";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$HOTSPOT_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOTSPOT_PSK";
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
  users.groups.network = { };
  #
  # systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
