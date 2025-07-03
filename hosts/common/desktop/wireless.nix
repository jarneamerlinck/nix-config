{
  config,
  ...
}: {

  sops.secrets."wireless/env" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };

  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets."wireless/env".path;
    networks = {
      "${config.sops.secrets."wireless/env/home_SSID"}" = {
        psk = "ext:home_psk";
        priority = 100;
      };
      "ext:homeIot_SSID" = {
        psk = "ext:homeIot_psk";
      };
      "ext:homeDad_SSID" = {
        psk = "ext:homeDad_psk";
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    scanOnLowSignal = true;
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
  # systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
