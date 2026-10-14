{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    simple-scan

  ];

}
