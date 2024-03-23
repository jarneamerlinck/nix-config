{ pkgs, lib, config, ... }:

{
  systemd.timers."auto-nix-rebuild" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Sat 2:00";
        Persistent = true;
        Unit = "auto-nix-rebuild.service";
      };
  };

  systemd.services."auto-nix-rebuild" = {
    script = ''
      set -eu
      cd /home/eragon/nix-config
      ./deploy.sh
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
