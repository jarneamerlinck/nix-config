{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette;
  themeName = "nix-color";
  colorPalette = ''

@define-color bg_color #${palette.base00};
@define-color fg_color #${palette.base02};
@define-color base_color #${palette.base01};
@define-color text_color #${palette.base05};
@define-color borders transparent;
@define-color header_bg_color #${palette.base00};
@define-color header_fg_color #${palette.base02};
@define-color selected_bg_color #${palette.base03};
@define-color tooltip_bg_color #${palette.base03};
@define-color tooltip_fg_color #${palette.base04};


@define-color text_color #${palette.base04};
@define-color theme_text_color @text_color;

@define-color accent_color #${palette.base0D};
@define-color accent_bg_color #${palette.base0D};
@define-color accent_fg_color #${palette.base00};
@define-color destructive_color #${palette.base08};
@define-color destructive_bg_color #${palette.base08};
@define-color destructive_fg_color #${palette.base00};
@define-color success_color #${palette.base0B};
@define-color success_bg_color #${palette.base0B};
@define-color success_fg_color #${palette.base00};
@define-color warning_color #${palette.base0E};
@define-color warning_bg_color #${palette.base0E};
@define-color warning_fg_color #${palette.base00};
@define-color error_color #${palette.base08};
@define-color error_bg_color #${palette.base08};
@define-color error_fg_color #${palette.base00};
@define-color window_bg_color #${palette.base00};
@define-color window_fg_color #${palette.base05};
@define-color view_bg_color #${palette.base00};
@define-color view_fg_color #${palette.base05};
@define-color headerbar_bg_color #${palette.base01};
@define-color headerbar_fg_color #${palette.base05};
@define-color headerbar_border_color ${palette.base01};
@define-color headerbar_backdrop_color @window_bg_color;
@define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
@define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
@define-color sidebar_bg_color #${palette.base01};
@define-color sidebar_fg_color #${palette.base05};
@define-color sidebar_backdrop_color @window_bg_color;
@define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
@define-color secondary_sidebar_bg_color @sidebar_bg_color;
@define-color secondary_sidebar_fg_color @sidebar_fg_color;
@define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
@define-color secondary_sidebar_shade_color @sidebar_shade_color;
@define-color card_bg_color #${palette.base01};
@define-color card_fg_color #${palette.base05};
@define-color card_shade_color rgba(0, 0, 0, 0.07);
@define-color dialog_bg_color #${palette.base01};
@define-color dialog_fg_color #${palette.base05};
@define-color popover_bg_color #${palette.base01};
@define-color popover_fg_color #${palette.base05};
@define-color popover_shade_color rgba(0, 0, 0, 0.07);
@define-color shade_color rgba(0, 0, 0, 0.07);
@define-color scrollbar_outline_color #${palette.base02};
@define-color menu_fg_color @theme_text_color;

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
}
