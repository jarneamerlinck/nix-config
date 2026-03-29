{ pkgs, ... }:
let
  nix = "${pkgs.nix}/bin/nix";
in
{
  programs.television.channels.nixpkgs = {
    metadata = {
      name = "nixpkgs";
      description = "Search and open nix shells for packages";
      requirements = [ "nix" ];
    };

    source = {
      command = "${nix} search nixpkgs . --json | jq -r 'keys[]'";
      no_sort = true;
    };

    keybindings = {
      enter = "actions:shell";
    };

    actions = {
      shell = {
        description = "Open nix shell with selected package";
        command = "nix shell nixpkgs#{}";
        mode = "execute";
      };
    };
  };
}
