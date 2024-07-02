{ outputs, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
  ];
  home.shellAliases = {
    fetch="fastfetch";
    neofetch="fastfetch -c neofetch";
    fullfetch="fastfetch -c all";
    hardware="fastfetch -c hardware";
  };

}
