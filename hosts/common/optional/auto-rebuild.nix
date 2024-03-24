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
      nix-shell https://github.com/jarneamerlinck/nix-config/tarball/feature/qemu
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
