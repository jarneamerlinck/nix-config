{
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Run each saturday on 2:00 AM
      "0 2 * * 6      root    cd /home/eragon/nix-config && ./deploy.sh"
    ];
  };
}
