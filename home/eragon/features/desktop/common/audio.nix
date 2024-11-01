{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) palette;
in {
  home.packages = with pkgs; [
    pavucontrol

  ];

}
