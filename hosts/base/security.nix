{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.fail2ban = {
    enable = true;
    extraPackages = [ pkgs.ipset ];
    banaction = "iptables-ipset-proto6-allports";
    maxretry = 5;
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };

  };
}
