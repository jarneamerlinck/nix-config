{ pkgs, ... }:
{
  systemd.services.framework-tablet-mode = {

    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    script = ''
      STATE_FILE="/tmp/buffer_tablet_mode"

      # Initialize state file if missing
      if [[ ! -f "$STATE_FILE" ]]; then
          echo "default" > "$STATE_FILE"
      fi

      LAST_STATE=$(cat "$STATE_FILE")


      ANGLE=$(${pkgs.framework-tool}/bin/framework_tool --sensors | grep "Lid Angle" | awk '{print $3}')
      if [[ -z "$ANGLE" ]]; then
          sleep 2
          continue
      fi

      # Higher than 260
      if (( ANGLE > 260 )); then
          if [[ "$LAST_STATE" == "default" ]]; then
              echo Switch specialization
              /nix/var/nix/profiles/system/specialisation/tablet/bin/switch-to-configuration switch
      	echo "tablet" > "$STATE_FILE"
          else
              echo $ANGLE
          fi
      fi

      # Lower than 250
      if (( ANGLE < 250 )); then
          if [[ "$LAST_STATE" == "tablet" ]]; then
              echo Switch specialization
              /nix/var/nix/profiles/system/specialisation/default/bin/switch-to-configuration switch
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
