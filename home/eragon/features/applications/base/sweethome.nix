{ pkgs, ... }:
{
  home.packages = with pkgs.sweethome3d; [
    application
    furniture-editor
    textures-editor
  ];
}
