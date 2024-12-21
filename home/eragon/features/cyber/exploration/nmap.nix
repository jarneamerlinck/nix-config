{ pkgs, ... }: {
  home.packages = with pkgs; [
    nmap
    nmap-formatter
  ];
}
