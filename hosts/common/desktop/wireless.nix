{
  config,
  ...
}: {

  sops.secrets."wireless/env" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = false;
  };

  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets."wireless/env".path;
    networks = {
      "knightofzero" = {
        psk = "ext:home_pwd";
        priority = 100;
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
