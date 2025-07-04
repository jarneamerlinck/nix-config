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
    secretsFile = [config.sops.secrets."wireless/env".path];
    networks = {
      "$homeDad_SSID" = {
        pskRaw = "ext:psk_homeDad";
        priority = 100;
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = false;
    scanOnLowSignal = true;
    userControlled = {
      enable = true;
      group = "users";
    };
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
  };
  #
  # # Ensure group exists
  users.groups.network = {};
  #
  # systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
