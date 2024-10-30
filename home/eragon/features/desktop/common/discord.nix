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
        --text-default: ${c.base04};
        --header-primary: ${c.base01};
        --header-secondary: ${c.base02};
        --channeltextarea-background: ${c.base09};
        --interactive-normal: ${c.base07};
        --interactive-active: ${c.base03};

        --dracula-primary: ${c.base01};
        --dracula-secondary: ${c.base02};
        --dracula-secondary-alpha: ${c.base03}ee;
        --dracula-tertiary: ${c.base04};
        --dracula-tertiary-alpha: ${c.base0A}aa;
        --dracula-primary-light: ${c.base0B};

        --dracula-accent: ${c.base01};
        --dracula-accent-alpha: ${c.base01}66;
        --dracula-accent-alpha-alt: ${c.base02}88;
        --dracula-accent-alpha-alt2: ${c.base03}aa;
        --dracula-accent-dark: ${c.base05};
        --dracula-accent-light: ${c.base06};
      }

      html.theme-light #app-mount::after {
        content: none;
      }
    '';
}
