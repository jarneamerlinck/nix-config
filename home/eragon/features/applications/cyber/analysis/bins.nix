{ pkgs, ... }: {
  home.packages = with pkgs; [
    upx
    binwalk
  ];
}
