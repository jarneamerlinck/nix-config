{ pkgs, config,  ... }:
let
  shell_script = if config.wayland.windowManager.hyprland.enable then "Hyprland"
            else if config.wayland.windowManager.sway.enable then "sway"
            else "sway";
in
{
  home = {
    packages = with pkgs; [
      wl-clipboard
      (pkgs.stdenv.mkDerivation {
        name = "greetd-session";
        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p $out/bin
          echo '#!/usr/bin/env sh' > $out/bin/greetd-session
          echo 'exec ${shell_script}' >> $out/bin/greetd-session
          chmod +x $out/bin/greetd-session 
        '';
      })
    ];
  };
}
