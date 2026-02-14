{
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [ lazydocker ];
  home.shellAliases = {
    d = "docker";
    ld = "lazydocker";
  };

}
