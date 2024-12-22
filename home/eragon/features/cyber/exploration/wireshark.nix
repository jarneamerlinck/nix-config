{ pkgs, ... }: {
  home.packages = with pkgs; [
    termshark
    wireshark
  ];
}
