{
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.compose2nix
  ];
}
