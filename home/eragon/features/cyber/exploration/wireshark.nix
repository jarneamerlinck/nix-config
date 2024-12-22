# Wireshark needs to be enabled on the host itself.
{ pkgs, ... }: {
  home.packages = with pkgs; [
    termshark
    tshark
  ];

  home.shellAliases = {
    "tshark" = "tshark --color";
  };
}
