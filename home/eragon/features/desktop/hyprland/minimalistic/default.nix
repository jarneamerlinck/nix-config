{
  pkgs,
  ...
}:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    procps
    jq
    playerctl
  ];

}
