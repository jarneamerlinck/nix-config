{ config, pkgs, ... }:
let
  wofiStyle = ''
    /* Wofi theme generated from nix-colors */

    #window {
      box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
      border-radius: 1rem;
      font-size: 1rem;
    }

    #window #outer-box {
    }

    #window #outer-box #input {
      border: none;
      padding: 0.8rem 1rem;
      font-size: 1.2rem;
      border-radius: 1rem 1rem 0 0;
    }

    #window #outer-box #input:focus,
    #window #outer-box #input:focus-visible,
    #window #outer-box #input:active {
      border: none;
      outline-offset: 2px;
    }

    #window #outer-box #scroll {
    }

    #window #outer-box #scroll #inner-box {
    }

    #window #outer-box #scroll #inner-box #entry {
      padding: 0.6rem 1rem;
    }

    #window #outer-box #scroll #inner-box #entry #img {
      margin-right: 0.5rem;
    }

    #window #outer-box #scroll #inner-box #entry:selected {
      outline: none;
    }
  '';
in {
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      image_size = 20;
      columns = 1;
      allow_images = true;
      insensitive = true;
      always_parse_args = true;
      cache_file = "/dev/null";
      exec_search = true;
      matching = "multi-contains";
      prompt = "kitty";
    };
    style = wofiStyle;
  };
}
