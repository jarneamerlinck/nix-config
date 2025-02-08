{ outputs, lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    k9s
  ];

  home.shellAliases = {
    h="helm";
    k="kubectl";
  };

}
