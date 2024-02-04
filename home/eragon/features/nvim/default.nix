{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    neovim
  ];
  # xdg.configFile."nvim".source =  builtins.fetchGit {
  #   url = "https://github.com/jarneamerlinck/kickstart.nvim";
  # };
  home.file.".config/nvim" = {
    source = "git+https://github.com/jarneamerlinck/kickstart.nvim";
    target = ".config/nvim";
  };
}
