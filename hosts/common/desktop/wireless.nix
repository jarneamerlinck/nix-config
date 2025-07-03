{
  config,
  ...
}: let
  sops_settings = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };
  wifi_networks = ["home" "iotHome"];

in  {

  sops.secrets = builtins.listToAttrs (
    (map (wifi: {
      name = "wireless/${wifi}/ssid";
      value = sops_settings;
    }) wifi_networks) ++
    (map (wifi: {
      name = "wireless/${wifi}/psw";
      value = sops_settings;
    }) wifi_networks)
  );

  networking.wireless = {
    enable = true;
    networks = builtins.listToAttrs (map (wifi: {
      name = config.sops.secrets."wireless/${wifi}/ssid".path;  # Dynamically get the SSID path
      value = {
        pskRaw = config.sops.secrets."wireless/${wifi}/psw".path;  # Dynamically get the PSK path
      };
    }) wifi_networks);

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
