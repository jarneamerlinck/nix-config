{ config, lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
  ];

  home.sessionVariables = {
    KUBECONFIG = "${config.home.homeDirectory}/.kube/config";
  };
  home.file.".kube/config" = {
    source = "/etc/rancher/k3s/k3s.yaml";
    target = "symlink";
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
