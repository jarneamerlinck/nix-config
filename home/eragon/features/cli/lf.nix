{ pkgs, config, ... }:
{
  xdg.configFile."lf/icons".source = ./icons;
  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };
    keybindings = {

      "\\\"" = "";
      o = "";
      c = "mkdir";
      "." = "set hidden!";
      # "`" = "mark-load";
      # "\\'" = "mark-load";
      "<enter>" = "open";

      do = "dragon-out";

      "g~" = "cd";
      gh = "cd";
      "g/" = "/";

      ee = "editor-open";
      V = ''$${pkgs.bat}/bin/bat --paging=always "$f"'';

      # ...
    };

    extraConfig =
      let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5

          # Small scaling tweak for lf
          w=$(( w * 99 / 100 ))
          h=$(( h * 99 / 100 ))
          y=$(( y + 1 ))

          # Determine mime type
          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            # Detect remote path like user@host:/path/to/image.png
            if [[ "$file" =~ ^([^:]+):(/.*) ]]; then
              host="''${BASH_REMATCH[1]}"
              remote_path="''${BASH_REMATCH[2]}"

              # Stream remote image data to local kitty (works over plain ssh)
              ssh "''${host}" "cat \"''${remote_path}\"" | \
                ${pkgs.kitty}/bin/kitty +kitten icat \
                  --transfer-mode buffer \
                  --stdin yes \
                  --place "''${w}x''${h}@''${x}x''${y}" - < /dev/null > /dev/tty
              exit 1
            fi

            # Local file path: use kitty directly
            ${pkgs.kitty}/bin/kitty +kitten icat \
              --silent \
              --stdin no \
              --transfer-mode file \
              --place "''${w}x''${h}@''${x}x''${y}" "$file" \
              < /dev/null > /dev/tty
            exit 1
          fi

          # Fallback to pistol for non-image files
          ${pkgs.pistol}/bin/pistol "$file"
        '';

        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat \
            --clear \
            --stdin no \
            --silent \
            --transfer-mode file < /dev/null > /dev/tty
        '';
      in
      ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
  };
}
