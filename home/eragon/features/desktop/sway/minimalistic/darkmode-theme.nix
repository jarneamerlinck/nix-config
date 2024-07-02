{ config, pkgs, ... }:
  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
    firefox_theme_ID = "{6d0cb08e-b66a-4738-afb1-f18300ed681e}"; # grey by varmed
  in
{
  programs = {

    wofi = {
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

    firefox = {
      profiles = {
        profile_0 = {
          settings = {
            "ui.systemUsesDarkTheme" = 1;
            "browser.in-content.dark-mode" = true;
            "extensions.activeThemeID" = "${toString firefox_theme_ID}";
          };
        };
      };
    };
  };

}
