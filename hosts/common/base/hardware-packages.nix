{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    pciutils
    openssl
  ];
}
