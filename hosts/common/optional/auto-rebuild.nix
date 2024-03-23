{
  systemd.timers."nix-auto-rebuild" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Sat 2:00";
        Persistent = true;
        Unit = "nix-auto-rebuild.service";
      };
  };

  systemd.services."nix-auto-rebuild" = {
    script = ''
      set -eu
      ${pkgs.coreutils}/bin/bash "cd /home/eragon/nix-config && ./deploy.sh"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
