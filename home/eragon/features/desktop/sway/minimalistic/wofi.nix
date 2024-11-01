{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette harmonized;
in {
  programs.wofi = {
      enable = true;
      settings = {
        allow_markup = true;
        image_size = 48;
        columns = 3;
        allow_images = true;
        insensitive = true;
        run-always_parse_args = true;
        run-cache_file = "/dev/null";
        run-exec_search = true;
        matching = "multi-contains";
    };
    style = ''
  * {
      font-family: monospace;
  }

  window {
      background-color: #${palette.base04};
  }

    '';
  };


}
