{ pkgs, ... }: {
  home.packages = with pkgs; [ lens.freelens ];

  #TODO: Add openLens as package, with extentions
}
