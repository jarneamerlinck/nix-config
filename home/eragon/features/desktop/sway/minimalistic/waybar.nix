{ pkgs, ... }: {
  programs.wofi = {
      enable = true;
      settings = {
        image_size = 48;
        columns = 3;
        allow_images = true;
        insensitive = true;
        run-always_parse_args = true;
        run-cache_file = "/dev/null";
        run-exec_search = true;
        matching = "multi-contains";
    };
  };

  programs.waybar = {
      enable = true;
      systemd.enable = true;
      style = builtins.readFile ./waybar_style.css;
  };
}
