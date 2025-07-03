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
    environmentFile = config.sops.secrets."wireless/env".path;
    networks = {
      "@home_SSID@" = {
        psk = "@home_psk@";
      };
      "@homeIot_SSID@" = {
        psk = "@homeIot_psk@";
      };
      "@homeDad_SSID@" = {
        psk = "@homeDad_psk@";
      };
    };

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
