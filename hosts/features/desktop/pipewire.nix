{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "99-disable-x11-bell" = {
        "context.modules" = [
          {
            name = "libpipewire-module-x11-bell";
            flags = [ "disabled" ];
          }
        ];
      };
    };
  };
}
