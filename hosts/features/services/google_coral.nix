{ pkgs, lib, ... }:
# Checkout https://github.com/jarneamerlinck/demo_flake.nix/tree/0.0.1-coral for uv2nix tflite inference with google coral support.
{
  hardware.coral.usb.enable = true;

  environment.systemPackages = with pkgs; [
    libedgetpu
    edgetpu-compiler
  ];
}
