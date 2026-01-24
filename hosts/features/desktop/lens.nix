{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [ lens.freelens ];
}
