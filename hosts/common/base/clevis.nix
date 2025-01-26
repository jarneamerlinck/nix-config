
{ pkgs,  ... }:
{
  boot.initrd.clevis.enable = true;
  environment.systemPackages = with pkgs; [
    tpm2-tss
    clevis
  ];
}
