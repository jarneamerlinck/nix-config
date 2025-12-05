{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ dragon-drop ];
    shellAliases = {
      dfzf = ''
        dragon "$(fzf -d '\n')"
      '';
    };
  };
}
