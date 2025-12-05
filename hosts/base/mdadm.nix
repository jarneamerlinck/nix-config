{
  outputs,
  lib,
  pkgs,
  ...
}:
{
  # needed for https://github.com/nix-community/disko/issues/451
  boot.swraid.mdadmConf = ''
    MAILADDR eragon@localhost
  '';
  environment.systemPackages = with pkgs; [ mailutils ];

}
