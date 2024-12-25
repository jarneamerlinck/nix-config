{
  config,
  pkgs,
  lib,
  ...
}: let
  mode = "Dark";
  inherit (builtins) hashString toJSON;
  inherit (config.colorscheme) palette;
  rendersvg = pkgs.runCommand "rendersvg" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.resvg}/bin/resvg $out/bin/rendersvg
  '';
  materiaTheme = name: colors:
    pkgs.stdenv.mkDerivation {
      name = "generated-gtk-theme";
      src = pkgs.fetchFromGitHub {
        owner = "nana-4";
        repo = "materia-theme";
        rev = "76cac96ca7fe45dc9e5b9822b0fbb5f4cad47984";
        sha256 = "sha256-0eCAfm/MWXv6BbCl2vbVbvgv8DiUH09TAUhoKq7Ow0k=";
      };
      buildInputs = with pkgs; [
        sassc
        bc
        which
        rendersvg
        meson
        ninja
        nodePackages.sass
        gtk4.dev
        optipng
      ];
      phases = ["unpackPhase" "installPhase"];
      installPhase = ''
        HOME=/build
        chmod 777 -R .
        patchShebangs .
        mkdir -p $out/share/themes
        mkdir bin
        sed -e 's/handle-horz-.*//' -e 's/handle-vert-.*//' -i ./src/gtk-2.0/assets.txt

        cat > /build/gtk-colors << EOF
          BTN_BG=${palette.base01}          # Button background
          BTN_FG=${palette.base07}          # Button foreground (text color)
          BG=${palette.base00}              # General background
          FG=${palette.base05}              # General foreground (text color)
          HDR_BTN_BG=${palette.base02}      # Header button background
          HDR_BTN_FG=${palette.base07}      # Header button foreground
          ACCENT_BG=${palette.base08}       # Accent background
          ACCENT_FG=${palette.base07}       # Accent foreground
          HDR_BG=${palette.base00}          # Header bar background
          HDR_FG=${palette.base05}          # Header bar foreground
          MATERIA_SURFACE=${palette.base01} # Surface color for Materia
          MATERIA_VIEW=${palette.base02}    # View color for Materia
          MENU_BG=${palette.base01}         # Menu background
          MENU_FG=${palette.base05}         # Menu text color
          SEL_BG=${palette.base08}          # Selected item background
          SEL_FG=${palette.base07}          # Selected item text color
          TXT_BG=${palette.base00}          # Text input background
          TXT_FG=${palette.base05}          # Text input text color
          WM_BORDER_FOCUS=${palette.base08} # Focused window border
          WM_BORDER_UNFOCUS=${palette.base01} # Unfocused window border
          UNITY_DEFAULT_LAUNCHER_STYLE=False # Unity launcher style
          NAME=${name}                      # Theme name
          MATERIA_STYLE_COMPACT=True        # Compact style for Materia
        EOF
        echo "Changing colours:"
        ./change_color.sh -o ${name} /build/gtk-colors -i False -t "$out/share/themes"
        chmod 555 -R .
      '';
    };
in rec {
  gtk = {
    enable = true;
    font = {
      inherit (config.fontProfiles.regular) name size;
    };
    theme = let
      inherit (config.colorscheme) colors;
      name = "generated-${hashString "md5" (toJSON colors)}-${mode}";
    in {
      inherit name;
      package = materiaTheme name (
        lib.mapAttrs (_: v: lib.removePrefix "#" v) colors
      );
    };
    iconTheme = {
      name = "Papirus-${"Dark"
      }";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      package = pkgs.apple-cursor;
      name = "macOS-BigSur";
      size = 24;
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
      "Net/IconThemeName" = "${gtk.iconTheme.name}";
    };
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
