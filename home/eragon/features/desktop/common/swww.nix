{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    swww
  ];
  services.swww = {
    enable = true;
  };

}
