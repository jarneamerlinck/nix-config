{ pkgs, ... }: {
  config.services.mako = {
    enable = true;
    anchor = "top-center";
    defaultTimeout = 2750;
  };
}
