{
  config,
  pkgs,
  ...
}: let
  c = config.colorscheme.palette;
in {
  home.packages = with pkgs; [vesktop];

  xdg.configFile."vesktop/themes/base16.css".text =
    /*
    css
    */
    ''
      @import url("https://slowstab.github.io/dracula/BetterDiscord/source.css");
      @import url("https://mulverinex.github.io/legacy-settings-icons/dist-native.css");
      .theme-dark, .theme-light, :root {
        --text-default: ${c.base03};
        --header-primary: ${c.base06};
        --header-secondary: ${c.base07};
        --channeltextarea-background: ${c.base08};
        --interactive-normal: ${c.base06};
        --interactive-active: ${c.base02};

        --dracula-primary: ${c.base00};
        --dracula-secondary: ${c.base01};
        --dracula-secondary-alpha: ${c.base02}ee;
        --dracula-tertiary: ${c.base03};
        --dracula-tertiary-alpha: ${c.base09}aa;
        --dracula-primary-light: ${c.base0A};

        --dracula-accent: ${c.base00};
        --dracula-accent-alpha: ${c.base00}66;
        --dracula-accent-alpha-alt: ${c.base01}88;
        --dracula-accent-alpha-alt2: ${c.base02}aa;
        --dracula-accent-dark: ${c.base04};
        --dracula-accent-light: ${c.base05};
      }

      html.theme-light #app-mount::after {
        content: none;
      }
    '';
}
