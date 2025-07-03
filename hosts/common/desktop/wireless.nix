{
  config,
  ...
}: {

  sops.secrets."wireless/env" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets."wireless/env".path;
    networks = {
      "@home_SSID@" = {
        psk = "ext:home_psk";
      };
      "@homeIot_SSID@" = {
        psk = "ext:homeIot_psk";
      };
      "@homeDad_SSID@" = {
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
  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
