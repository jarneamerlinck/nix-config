{ inputs }:
{
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake:
      let
        legacyPackages = ((flake.legacyPackages or { }).${final.system} or { });
        packages = ((flake.packages or { }).${final.system} or { });
      in
      if legacyPackages != { } then legacyPackages else packages
    ) inputs;
  };

  # Adds my custom packages
  additions =
    final: _prev:
    import ../pkgs { pkgs = final; }
    // {
      # formats = (prev.formats or {}) // import ../pkgs/formats { pkgs = final; };
      # vimPlugins = (prev.vimPlugins or {}) // import ../pkgs/vim-plugins { pkgs = final; };
    };

  # Modifies existing packages
  modifications = _final: _prev: {

    # pfetch = prev.pfetch.overrideAttrs (oldAttrs: {
    #   version = "unstable-2021-12-10";
    #   src = final.fetchFromGitHub {
    #     owner = "dylanaraps";
    #     repo = "pfetch";
    #     rev = "a906ff89680c78cec9785f3ff49ca8b272a0f96b";
    #     sha256 = "sha256-9n5w93PnSxF53V12iRqLyj0hCrJ3jRibkw8VK3tFDvo=";
    #   };
    #   # Add term option, rename de to desktop, add scheme option
    #   patches = (oldAttrs.patches or [ ]) ++ [ ./pfetch.patch ];
    # });

  };
}
