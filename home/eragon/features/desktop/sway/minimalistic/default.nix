{
  pkgs,
  config,
  ...
}:
let
  i_keyboard = "be";
  cfg = config.wayland.windowManager.sway.config;

in
{
  imports = [
    ../common
    ./shotman.nix
    ./wofi.nix
    ./waybar.nix
    ./notifications.nix
    ./darkmode-theme.nix
    ./swaylock.nix
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

        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";
        "${cfg.modifier}+Escape" = "exec ${config.programs.swaylock.package}/bin/swaylock";
        # "${cfg.modifier}+Shift+Escape" = "exec ${pkgs.swaylock-effects}/bin/swaylock -C /home/${config.home.username}/.config/swaylock/config";
        "${cfg.modifier}+Shift+l" = "exec swaymsg exit";
        "${cfg.modifier}+Shift+r" = "exec swaymsg reload";

        # full screen modes
        "${cfg.modifier}+f" = "fullscreen toggle";
        "${cfg.modifier}+F11" = "exec systemctl is-active --user --quiet waybar && systemctl --user stop waybar || systemctl --user start waybar";


        "Ctrl+Alt+Right" = "workspace next";
        "Ctrl+Alt+Left" = "workspace prev";
        "Ctrl+Alt+1" = "workspace 1";
        "Ctrl+Alt+2" = "workspace 2";
        "Ctrl+Alt+3" = "workspace 3";
        "Ctrl+Alt+4" = "workspace 4";
        "Print" = "exec ${pkgs.shotman}/bin/shotman -c output -C";


        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" =  "exec light -A 10";
        "XF86AudioRaiseVolume" =  "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        "XF86AudioLowerVolume" =  "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        "XF86AudioMute" =  "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
      };
    };
    extraConfig = ''
      for_window [app_id="firefox"] move to workspace 2
      for_window [app_id="code"] move to workspace 3
      for_window [app_id="vesktop"] move to workspace 4
      for_window [title=".*Discord.*"] move to workspace 4
      for_window [title=".*Feishin.*"] move to workspace 4

      exec swaymsg workspace 4
      exec swaymsg workspace 3
      exec swaymsg workspace 2
      exec swaymsg workspace 1
      input "type:keyboard" {
        xkb_layout ${i_keyboard}
      }
    '';
  };
}
