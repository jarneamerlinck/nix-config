{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs;
    [ inputs.hexecute.packages.${pkgs.system}.default ];
}
