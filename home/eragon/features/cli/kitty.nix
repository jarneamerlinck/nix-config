{ config, lib, pkgs, ... }:
let
  rmHash = lib.removePrefix "#";
  inherit (config.colorscheme) palette;
  kittyColors = ''
    # Colors generated from nix-colors
    foreground #${rmHash palette.base05}
    background #${rmHash palette.base00}
    cursor #${rmHash palette.base05}

    color0  #${rmHash palette.base00}
    color1  #${rmHash palette.base08}
    color2  #${rmHash palette.base0B}
    color3  #${rmHash palette.base0A}
    color4  #${rmHash palette.base0D}
    color5  #${rmHash palette.base0E}
    color6  #${rmHash palette.base0C}
    color7  #${rmHash palette.base05}

    color8  #${rmHash palette.base03}
    color9  #${rmHash palette.base08}
    color10 #${rmHash palette.base0B}
    color11 #${rmHash palette.base0A}
    color12 #${rmHash palette.base0D}
    color13 #${rmHash palette.base0E}
    color14 #${rmHash palette.base0C}
    color15 #${rmHash palette.base07}
  '';
in
{
  programs.kitty = {
    enable = true;
    # theme = "Tokyo Night";
    font.name = "${config.fontProfiles.monospace.family}";
    keybindings = {
      "super+v" = "paste_from_clipboard";
      "ctrl+shift+s" = "paste_from_selection";
      "super+c" = "copy_to_clipboard";
      "shift+insert" = "paste_from_selection";
      "ctrl+shift+k" = "scroll_line_up";
      "ctrl+shift+j" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      "ctrl+shift+h" = "show_scrollback";
      "super+n" = "new_os_window";
      "super+w" = "close_window";
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "move_window_forward";
      "ctrl+shift+b" = "move_window_backward";
      "ctrl+shift+`" = "move_window_to_top";
      "ctrl+shift+1" = "first_window";
      "ctrl+shift+2" = "second_window";
      "ctrl+shift+3" = "third_window";
      "ctrl+shift+4" = "fourth_window";
      "ctrl+shift+5" = "fifth_window";
      "ctrl+shift+6" = "sixth_window";
      "ctrl+shift+7" = "seventh_window";
      "ctrl+shift+8" = "eighth_window";
      "ctrl+shift+9" = "ninth_window";
      "ctrl+shift+0" = "tenth_window";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
      "ctrl+shift+up" = "increase_font_size";
      "ctrl+shift+down" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
    };
    settings = {
      font_family = "${config.fontProfiles.monospace.family}";
      italic_font = "auto";
      bold_font = "auto";
      bold_italic_font = "auto";
      font_size = 12;
      background_opacity = "0.9";
      cursor_shape = "block";
      cursor_stop_blinking_after = 15;
      scrollback_lines = 2000;
      scrollback_pager = "less +G -R";
      select_by_word_characters = ":@-./_~?&=%+#";
      enabled_layouts = "*";
      remember_window_size = false;
      repaint_delay = 10;
      input_delay = 3;
      visual_bell_duration = 0;
      enable_audio_bell = false;
      open_url_modifiers = "ctrl+shift";
      open_url_with = "default";
      term = "xterm-kitty";
      window_border_width = 0;
      window_margin_width = 15;

      hide_window_decorations = "yes";
      macos_option_as_alt = false;
      initial_window_width = 2500;
      initial_window_height = 1380;
      macos_titlebar_color = "background";
      };
      extraConfig = kittyColors;
  };
}
