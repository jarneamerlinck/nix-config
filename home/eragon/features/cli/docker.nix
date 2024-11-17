{ outputs, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    docker
  ];
  home.shellAliases = {
    d="docker";
  };

}
