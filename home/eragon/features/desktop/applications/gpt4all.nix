{ pkgs, config, ... }: {

  home = {
    packages = with pkgs; [
      gpt4all
    ];
  };
}
