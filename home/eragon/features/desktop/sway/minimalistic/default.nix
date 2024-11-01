{ inputs, lib, pkgs, config, outputs, ... }:
let
  i_keyboard = "be";
  cfg = config.wayland.windowManager.sway.config;

in
{
  imports = [
    ../common
    ./shotman.nix
    ./waybar.nix
    ./notifications.nix
    ./darkmode-theme.nix
  ];

  home.packages = with pkgs; [
    procps
    jq
    playerctl
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # super key
      terminal = "${pkgs.kitty}/bin/kitty";
      bars = [];
      keybindings = {
        "${cfg.modifier}+t" = "exec ${cfg.terminal}";
        "${cfg.modifier}+d" = "exec ${pkgs.wofi}/bin/wofi -S drun -x 10 -y 10 -W 25% -H 60%";
        "${cfg.modifier}+q" = "kill";
        "${cfg.modifier}+b" = "exec ${pkgs.firefox}/bin/firefox";

        "${cfg.modifier}+${cfg.left}" = "focus left";
        "${cfg.modifier}+${cfg.down}" = "focus down";
        "${cfg.modifier}+${cfg.up}" = "focus up";
        "${cfg.modifier}+${cfg.right}" = "focus right";

        "${cfg.modifier}+Shift+${cfg.left}" = "move left";
        "${cfg.modifier}+Shift+${cfg.down}" = "move down";
        "${cfg.modifier}+Shift+${cfg.up}" = "move up";
        "${cfg.modifier}+Shift+${cfg.right}" = "move right";
        "${cfg.modifier}+f" = "fullscreen toggle";
        "${cfg.modifier}+Shift+Escape" = "exec swaymsg exit";
        "${cfg.modifier}+Shift+c" = "exec swaymsg reload";
      };
      modes = {
        workspace_mode =
        {
          "0" = "workspace 0";
          "1" = "workspace 1";
          "2" = "workspace 2";
          "3" = "workspace 3";
          "4" = "workspace 4";
          "5" = "workspace 5";
          "6" = "workspace 6";
          "7" = "workspace 7";
          "8" = "workspace 8";
          "9" = "workspace 9";
          "${cfg.right}" = "workspace next";
          "${cfg.left}" = "workspace prev";
        };
      };
    };
    extraConfig = ''
      input "type:keyboard" {
        xkb_layout ${i_keyboard}
      }
    '';
  };
}
