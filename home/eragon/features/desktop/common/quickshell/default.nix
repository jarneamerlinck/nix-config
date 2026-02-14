{ config, ... }:
let
  fontSize = toString config.stylix.fonts.sizes.desktop;
in
{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."quickshell/shell.qml".text = with config.lib.stylix.colors.withHashtag; ''
    import Quickshell
    # import "file:${config.home.homeDirectory}/.config/quickshell/components"

    Scope {
      id: root

      property var theme: ({
        base00: "${base00}",
        base01: "${base01}",
        base03: "${base03}",
        base05: "${base05}",
        base0C: "${base0C}",
        base08: "${base08}",

        monospaceFont: ${builtins.toJSON config.stylix.fonts.monospace.name},
        emojiFont: ${builtins.toJSON config.stylix.fonts.emoji.name},
        fontSize: ${fontSize},

        barHeight: 40,
        radius: 5,

        widgetBg: "${base01}",
        widgetBorder: "${base03}",
        fg: "${base05}",
        danger: "${base08}"
      })

      Bar {
        theme: root.theme
      }
    }
  '';
}
