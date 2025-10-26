# Wireshark needs to be enabled on the host itself.
{ pkgs, ... }: {
  home.packages = with pkgs; [ termshark tshark tcpdump ];

  home.shellAliases = { "tshark" = "tshark --color"; };
}
