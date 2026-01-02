{
  pkgs,
  ...
}:
let
  enable_sys_nice = false;
in
{

  programs.gamemode = {
    enable = true;
    enableRenice = enable_sys_nice;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = enable_sys_nice;
  };
  environment.systemPackages = with pkgs; [
    gamescope-wsi # HDR won't work without this
    protonup-qt
  ];

}
