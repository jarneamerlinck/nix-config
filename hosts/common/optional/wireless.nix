{
  config,
  ...
}: {
  # Wireless secrets stored through sops
  sops.secrets.wireless_kightofzero = {
    sopsFile = ../secrets.yml;
    neededForUsers = true;
  };
  sops.secrets.wireless = {
    sopsFile = ../secrets.yml;
    neededForUsers = true;
  };
  environment.etc."wireless-debug.txt".text =  toString config.sops.secrets.wireless.path;
  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    # networks = map (n: {
    #   ssid = n.ssid;
    #   psk = n.psw;
    # }) (builtins.fromJSON config.sops.secrets.wireless);
    # networks.home = {
    #   ssid = config.sops.secrets.wireless.ssid;
    #   psk = config.sops.secrets.wireless.kightofzero;
    # };

    # networks.iothome = {
    #   ssid = config.sops.secrets.wireless[1].iothome.SSID;
    #   psk = config.sops.secrets.wireless[1].iothome.PSW;
    # };
    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      update_config=1
    '';
  };
  #
  # # Ensure group exists
  users.groups.network = {};
  #
  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
