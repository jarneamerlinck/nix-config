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
    path = with pkgs; [
      nix
      git
    ];
    script = ''
      git config --global --add safe.directory /home/eragon/nix-config
      cd /home/eragon/nix-config
      git stash && git pull
      ./deploy.sh
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
