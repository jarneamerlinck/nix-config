{
  config,
  lib,
  pkgs,
  ...
}:
let
  ## Notify Users Script
  notifyUsersScript = pkgs.writeScript "notify-users.sh" ''
    set -eu

    title="$1"
    body="$2"

    users=$(${pkgs.systemd}/bin/loginctl list-sessions --no-legend | ${pkgs.gawk}/bin/awk '{print $1}' | while read session; do
      loginctl show-session "$session" -p Name | cut -d'=' -f2
    done | sort -u)

    for user in $users; do
      [ -n "$user" ] || continue
      uid=$(id -u "$user") || continue
      [ -S "/run/user/$uid/bus" ] || continue

      # Send notification
      ${pkgs.sudo}/bin/sudo -u "$user" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
        ${pkgs.libnotify}/bin/notify-send "$title" "$body" || true

    done
  '';

  ## Update Git and Channel Script
  updateGitScript = pkgs.writeScript "update-git.sh" ''
    set -eu
    ${pkgs.git}/bin/git -C /etc/nix-config pull --rebase
  '';

  buildAndBoot = pkgs.writeScript "rebuild-and-boot.sh" ''
    set -eu
    ${pkgs.nh}/bin/nh os boot
  '';

in
{
  # Permissions
  systemd.tmpfiles.rules = [
    "d /etc/nix-config 2775 eragon users -"
  ];
  # Auto update config and channel
  systemd.timers."auto-upgrade-config" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon,Thu";
      Persistent = true;
      Unit = "auto-upgrade.service";
    };
  };

  systemd.services."auto-update" = {
    script = ''
      set -eu
      # Ensure /run/wrappers/bin comes first so sudo works with proper setuid permissions
      export PATH=/run/wrappers/bin:${pkgs.nixos-rebuild}/bin:${pkgs.nh}/bin:${pkgs.nix}/bin:${pkgs.openssh}/bin:${pkgs.systemd}/bin:${pkgs.util-linux}/bin:${pkgs.coreutils-full}/bin:$PATH

      ${updateGitScript}

    '';
    serviceConfig = {
      Type = "oneshot";
      User = "eragon";
      Restart = "on-failure";
      RestartSec = "30s";
      CPUWeight = "20";
      IOWeight = "20";
      MemoryHigh = "500M";
    };

    after = [
      "network-online.target"
      "graphical.target"
    ];
    wants = [ "network-online.target" ];
  };
  systemd.services."auto-upgrade" = {
    script = ''
      set -eu
      # Ensure /run/wrappers/bin comes first so sudo works with proper setuid permissions
      export PATH=/run/wrappers/bin:${pkgs.nixos-rebuild}/bin:${pkgs.nh}/bin:${pkgs.nix}/bin:${pkgs.openssh}/bin:${pkgs.systemd}/bin:${pkgs.util-linux}/bin:${pkgs.coreutils-full}/bin:$PATH

      ${notifyUsersScript} "Starting System Updates" "System updates are installing in the background. You can continue to use your computer while these are running."

      nixos-rebuild boot --flake /etc/nix-config#$HOSTNAME

      ${notifyUsersScript} "System Updates Complete" "Updates are complete! Simply reboot the computer whenever is convenient to apply updates."
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Restart = "on-failure";
      RestartSec = "30s";
      CPUWeight = "20";
      IOWeight = "20";
      MemoryHigh = "900M";
    };
    requires = [
      "auto-update.service"
    ];
    after = [
      "network-online.target"
      "graphical.target"
      "auto-update.service"
    ];
    wants = [ "network-online.target" ];
  };
}
