{ pkgs, config, ... }:
{

  home.packages = with pkgs; [
    excalidraw.excalidraw
  ];

}
