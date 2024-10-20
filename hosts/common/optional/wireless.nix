{
  config,
  ...
}: {
  # Wireless secrets stored through sops
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    # Declarative
    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "ext:home_ssid" = {
        pskRaw = "ext:home_psw";
      };
      "ext:iothome_ssid" = {
        pskRaw = "ext:iothome_psw";
      };


    };
  };

    # Imperative
  #   allowAuxiliaryImperativeNetworks = true;
  #   userControlled = {
  #     enable = true;
  #     group = "network";
  #   };
  #   extraConfig = ''
  #     update_config=1
  #   '';
  # };
  #
  # # Ensure group exists
  # users.groups.network = {};
  #
  # systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
