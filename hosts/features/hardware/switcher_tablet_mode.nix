{ pkgs, ... }:
{
  systemd.services.framework-tablet-mode = {

    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    path = [
      pkgs.bash
      pkgs.framework-tool
      pkgs.gawk
      pkgs.gnugrep
      pkgs.util-linux
      pkgs.firefox
    ];
    script = ''
      STATE_FILE="/tmp/buffer_tablet_mode"
      FIREFOX_PID_FILE="/tmp/tablet_kiosk_firefox.pid"

      # Initialize state file if missing
      if [[ ! -f "$STATE_FILE" ]]; then
          echo "default" > "$STATE_FILE"
      fi

      LAST_STATE=$(cat "$STATE_FILE")


      ANGLE=$(framework_tool --sensors | grep "Lid Angle" | awk '{print $3}')
      if [[ -z "$ANGLE" ]]; then
          sleep 2
          continue
      fi

      # Higher than 260
      if (( ANGLE > 260 )); then
          if [[ "$LAST_STATE" == "default" ]]; then
              echo Switch specialization
              # /nix/var/nix/profiles/system/specialisation/tablet/bin/switch-to-configuration switch
              runuser -u eragon -- \
                    firefox --new-window --kiosk http://localhost:6767 &
      	echo "tablet" > "$STATE_FILE"
          else
              echo $ANGLE
          fi
      fi

      # Lower than 250
      if (( ANGLE < 250 )); then
          if [[ "$LAST_STATE" == "tablet" ]]; then
              echo Switch specialization
              # /nix/var/nix/profiles/system/specialisation/default/bin/switch-to-configuration switch


              if [[ -f "$FIREFOX_PID_FILE" ]]; then
                  PID=$(cat "$FIREFOX_PID_FILE")

                  if kill -0 "$PID" 2>/dev/null; then
                      kill "$PID"
                  fi

                  rm -f "$FIREFOX_PID_FILE"
              fi
      	echo "default" > "$STATE_FILE"
          else
              echo $ANGLE
          fi
      fi
    '';
    serviceConfig = {
      enable = true;
      Type = "simple";
      User = "root";
      Restart = "always";
      RestartSec = 2;
    };
  };
}
