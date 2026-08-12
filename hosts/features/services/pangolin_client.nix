{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pangolin-cli
  ];
}
