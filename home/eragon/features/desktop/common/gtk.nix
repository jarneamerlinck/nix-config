{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette;
  themeName = "nix-color";
  colorPalette = ''
    /* GTK Theme generated from nix-colors */

    @define-color base00 ${palette.base00};
    @define-color base01 ${palette.base01};
    @define-color base02 ${palette.base02};
    @define-color base03 ${palette.base03};
    @define-color base04 ${palette.base04};
    @define-color base05 ${palette.base05};
    @define-color base06 ${palette.base06};
    @define-color base07 ${palette.base07};
    @define-color base08 ${palette.base08};
    @define-color base09 ${palette.base09};
    @define-color base0A ${palette.base0A};
    @define-color base0B ${palette.base0B};
    @define-color base0C ${palette.base0C};
    @define-color base0D ${palette.base0D};
    @define-color base0E ${palette.base0E};
    @define-color base0F ${palette.base0F};

    /* Example GTK styles leveraging the defined colors */
    * {
      background-color: @base00;
      color: @base05;
    }

    button {
      background-color: @base01;
      color: @base07;
      border-color: @base03;
    }

    window, dialog, popover {
      background-color: @base00;
      color: @base05;
    }

    box, grid, stack {
      background-color: @base00;
    }
    /* Additional GTK styling can be customized here */
  '';
in {
  home.file.".themes/${themeName}/gtk-2.0/gtk.css".text = colorPalette;
  home.file.".themes/${themeName}/gtk-3.0/gtk.css".text = colorPalette;
  home.file.".themes/${themeName}/gtk-4.0/gtk.css".text = colorPalette;

  gtk = {
    enable = true;
    theme = {
      name = "${themeName}";
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${themeName}";
      "Net/IconThemeName" = "${config.fontProfiles.regular.family}";
    };
  };
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
