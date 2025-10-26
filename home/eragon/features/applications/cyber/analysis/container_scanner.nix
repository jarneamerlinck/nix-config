{ pkgs, ... }: {

  home.packages = with pkgs; [ grype syft ];
}
