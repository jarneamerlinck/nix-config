{ pkgs, ... }: {
  home.packages = with pkgs; [
    zenmap
  ];
}
