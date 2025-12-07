{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{

  options = {

    desktop.compositor = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable compositor module module";
          };

          type = lib.mkOption {
            type = lib.types.enum [
              "x11"
              "wayland"
            ];
            default = "wayland";
            description = "Compositor to use";
          };
        };
      };
    };
  };

  config = lib.mkIf config.desktop.compositor.enable lib.mkMerge [

    (lib.mkIf (config.desktop.compositor.enable) {

      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
      programs.dconf.enable = true;
    })
    (lib.mkIf (config.desktop.compositor.type == "x11") {

      environment.systemPackages = with pkgs; [ xdg-desktop-portal ];
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };

    })

    (lib.mkIf (config.desktop.compositor.type == "wayland") {

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      security.polkit.enable = true;
      hardware.graphics.enable = true; # Only enable inside VM
      programs.xwayland.enable = true;

      environment.systemPackages = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];

      # Keyrign
      services.gnome.gnome-keyring.enable = true;

      # Keyboard lights
      programs.light = {
        enable = true;
        brightnessKeys.enable = true;
      };

      # Securtiy
      security.pam.services.swaylock = { };
    })
  ];
}
