{ pkgs, config, ... }: {

  home = {
    packages = with pkgs; [
      onlyoffice-desktopeditors
    ];
  };
}
