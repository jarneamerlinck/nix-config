{ lib, pkgs, inputs, ... }: {
  imports = [
    ../base
    ../features/applications/base
    ../features/desktop/sway/minimalistic
    ../features/applications/base/vscode.nix
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
