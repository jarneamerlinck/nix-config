{ pkgs, ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Hack Nerd Font";
      package = pkgs.nerd-fonts.hack;
    };
    regular = {
      family = "Hack Nerd Font";
      package = pkgs.nerd-fonts.hack;
    };
  };
}
