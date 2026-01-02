{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0811", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  programs.bash.shellAliases = {
    keychron = "nix shell nixpkgs#google-chrome --impure -c google-chrome-stable https://launcher.keychron.com";
  };

  programs.zsh.shellAliases = {
    keychron = "nix shell nixpkgs#google-chrome --impure -c google-chrome-stable https://launcher.keychron.com";
  };

}
