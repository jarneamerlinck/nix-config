{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    metasploit
    thc-hydra
    gobuster
    volatility3
    enum4linux
    nikto
    wpscan
    exploitdb
    netcat
    cyberchef
    upx
    # wireshark-qt
    tshark
    saleae-logic-2
    binwalk
    mosquitto
    mediamtx
  ];
}
