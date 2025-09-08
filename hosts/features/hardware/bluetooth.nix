{
  pkgs,  ...
}:
{

  environment.systemPackages = with pkgs; [
    bluetui
  ];
}
