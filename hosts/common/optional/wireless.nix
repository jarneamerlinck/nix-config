{
  config,
  ...
}: {
  # Wireless secrets stored through sops
  sops.secrets.wireless_kightofzero = {
    sopsFile = ../secrets.yml;
    neededForUsers = true;
  };
  #   sops.secrets.wireless.home.PSW = {
  #   sopsFile = ../secrets.yml;
  #   neededForUsers = true;
  # };

  networking.wireless = {
    networks.home = {
      ssid = "knightofzero";
      psk = config.sops.secrets.wireless.kightofzero;
    };

    # networks.iothome = {
    #   ssid = config.sops.secrets.wireless[1].iothome.SSID;
    #   psk = config.sops.secrets.wireless[1].iothome.PSW;
    # };
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
