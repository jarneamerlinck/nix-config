{  pkgs, ... }:{
  home.packages = with pkgs; [
    piper
    solaar
  ];
}
