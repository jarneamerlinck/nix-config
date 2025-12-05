{ pkgs, ... }:
{
  systemd.user.services."checkNixConfig" = {
    Service = {
      ExecStart = ''
        ${pkgs.zsh}/bin/zsh -c 'if [ ! -d "$HOME/nix-config" ]; then git clone https://github.com/jarneamerlinck/nix-config "$FLAKE"; fi'
      '';
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
