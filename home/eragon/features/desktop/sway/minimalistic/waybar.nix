{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  rmHash = lib.removePrefix "#";
  inherit (config.colorscheme) palette harmonized;

  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils}/bin/cut";
  find = "${pkgs.findutils}/bin/find";
  grep = "${pkgs.gnugrep}/bin/grep";
  pgrep = "${pkgs.procps}/bin/pgrep";
  tail = "${pkgs.coreutils}/bin/tail";
  wc = "${pkgs.coreutils}/bin/wc";
  xargs = "${pkgs.findutils}/bin/xargs";
  timeout = "${pkgs.coreutils}/bin/timeout";
  ping = "${pkgs.iputils}/bin/ping";

  jq = "${pkgs.jq}/bin/jq";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";

  # Function to simplify making waybar outputs
  jsonOutput =
    name:
    {
      pre ? "",
      text ? "",
      tooltip ? "",
      alt ? "",
      class ? "",
      percentage ? "",
    }:
    "${pkgs.writeShellScriptBin "waybar-${name}" ''
      set -euo pipefail
      ${pre}
      ${jq} -cn \
        --arg text "${text}" \
        --arg tooltip "${tooltip}" \
        --arg alt "${alt}" \
        --arg class "${class}" \
        --arg percentage "${percentage}" \
        '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
    ''}/bin/waybar-${name}";

  hasSway = config.wayland.windowManager.sway.enable;
  sway = config.wayland.windowManager.sway.package;
in
{
  programs.wofi = {
      enable = true;
      settings = {
        image_size = 48;
        columns = 3;
        allow_images = true;
        insensitive = true;
        run-always_parse_args = true;
        run-cache_file = "/dev/null";
        run-exec_search = true;
        matching = "multi-contains";
    };
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    style = ''
  * {
    border: none;
    border-radius: 0;
    font-family: Source Code Pro;
  }
  window#waybar {
    background-color: transparent;
    color: #${palette.base04};
  }
  #workspaces button {
    padding: 0 5px;
  }
'';
    settings = {
      primary = {
        spacing = 12;
        mode = "dock";
        layer = "top";
        height = 40;
        margin = "6";
        position = "top";
        modules-left =
          [ "custom/menu" ]
          ++ (lib.optionals hasSway [
            "sway/workspaces"
            "sway/mode"
          ]);

        modules-center = [
          "cpu"
          "custom/gpu"
          "memory"
          "clock"
          "pulseaudio"
          "battery"
        ];

        modules-right = [
          "tray"
          "network"
          "custom/hostname"
        ];

        clock = {
          interval = 1;
          format = "{:%d/%m/%Y %H:%M:%S}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        cpu = {
          format = "  {usage}%";
        };
        "custom/gpu" = {
          interval = 5;
          exec = "${cat} /sys/class/drm/card0/device/gpu_busy_percent";
          format = "󰒋  {}%";
        };
        memory = {
          format = "  {}%";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };
        "custom/menu" =
          let
            isFullScreen = "false";
          in
          {
            interval = 1;
            return-type = "json";
            exec = jsonOutput "menu" {
              text = "";
            };
            on-click = "${pkgs.wofi}/bin/wofi -S drun -x 10 -y 10 -W 25% -H 60%";
          };
        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
          on-click = "${systemctl} --user restart waybar";
        };
      };
    };
  };
}
