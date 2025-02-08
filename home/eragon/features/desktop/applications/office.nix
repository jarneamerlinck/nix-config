{ pkgs, config, ... }: {

  home = {
    packages = with pkgs; [
      onlyoffice-documentserver
    ];
  };
}
