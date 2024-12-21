{ pkgs, ... }: {
  home.packages = with pkgs; [
    termshark
    wireshark
  ];
  groups.wireshark = {};
}
