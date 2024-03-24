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
    path = [ pkgs.nix ];
    script = ''
      cd /home/eragon/nix-config;
      git stash && git pull
      ./deploy.sh
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
