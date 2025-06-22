{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      wl-clipboard
      (pkgs.writeShellScriptBin "greetd-session" ''
        #!/bin/sh
        exec Hyprland  # or sway, or a custom script
      '')
    ];
  };
}
