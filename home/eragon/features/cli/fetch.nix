{ pkgs, ... }:
{
  programs.fastfetch.enable = true;
  home.shellAliases = {
    fetch = "fastfetch";
    neofetch = "fastfetch -c neofetch";
    fullfetch = "fastfetch -c all";
    hardware = "fastfetch -c hardware";
  };
  home.packages = with pkgs; [ nvtopPackages.intel ];

}
