{ pkgs, ... }: {
  home.packages = with pkgs; [
    binwalk
  ];
}

