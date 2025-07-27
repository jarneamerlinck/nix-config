{ pkgs, ... }: {
  home.packages = with pkgs; [
    libnotify
  ];
  config.services.mako = {
    enable = true;
    settings = {
      anchor = "top-center";
      default-timeout = 2750;
    };
  };
}
