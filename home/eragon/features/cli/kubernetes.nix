{ config, lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    kubeseal
    lens.freelens

  ];

  #TODO: Add openLens as package, with extentions




  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  programs.k9s = {
    enable= true;

    plugin = {
      # Defines a plugin to provide a `ctrl-l` shortcut to
      # tail the logs while in pod view.
      fred = {
        shortCut = "Ctrl-L";
        description = "Pod logs";
        scopes = [ "po" ];
        command = "kubectl";
        background = false;
        args = [
          "logs"
          "-f"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CLUSTER"
        ];
      };
    };

  };

  home.shellAliases = {
    h="helm";
    k="kubectl";
  };

}
