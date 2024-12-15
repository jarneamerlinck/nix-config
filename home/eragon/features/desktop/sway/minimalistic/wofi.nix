{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette;
  wofiStyle = ''
    /* Wofi theme generated from nix-colors */

    #window {
      box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
      border-radius: 1rem;
      font-size: 1rem;
      background-color: #${palette.base00};
      color: #${palette.base05};
    }

    #window #outer-box {
      background-color: #${palette.base01};
    }

    #window #outer-box #input {
      border: none;
      padding: 0.8rem 1rem;
      font-size: 1.2rem;
      border-radius: 1rem 1rem 0 0;
      background-color: #${palette.base02};
      color: #${palette.base05};
    }

    #window #outer-box #input:focus,
    #window #outer-box #input:focus-visible,
    #window #outer-box #input:active {
      border: none;
      outline: 2px solid #${palette.base05};
      outline-offset: 2px;
    }

    #window #outer-box #scroll {
      background-color: #${palette.base01};
    }

    #window #outer-box #scroll #inner-box {
      background-color: #${palette.base01};
    }

    #window #outer-box #scroll #inner-box #entry {
      padding: 0.6rem 1rem;
      background-color: #${palette.base00};
      color: #${palette.base05};
    }

    #window #outer-box #scroll #inner-box #entry #img {
      width: 1rem;
      margin-right: 0.5rem;
    }

    #window #outer-box #scroll #inner-box #entry:selected {
      outline: none;
      background-color: #${palette.base02};
      color: #${palette.base07};
    }
  '';
in {
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      image_size = 20;
      columns = 3;
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
      run-exec_search = true;
      matching = "multi-contains";
    };
    style = wofiStyle;
  };
}
