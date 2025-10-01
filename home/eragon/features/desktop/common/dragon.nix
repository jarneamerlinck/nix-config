{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ xdragon ];
    shellAliases = {
      dfzf = ''
        dragon "$(fzf -d '\n')"
      '';
    };
  };
}
