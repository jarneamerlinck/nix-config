{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette;
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
    style = ''
/* The name of the window itself */
#window {
  background-color: #${palette.base01};
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
  border-radius: 1rem;
  font-size: 1rem;
  /* The name of the box that contains everything */
}
#window #outer-box {
  /* The name of the search bar */
  /* The name of the scrolled window containing all of the entries */
}
#window #outer-box #input {
  background-color: #${palette.base02};
  color: #${palette.base06};
  border: none;
  border-bottom: 1px solid #${palette.base00};
  padding: 0.8rem 1rem;
  font-size: 1.2rem;
  border-radius: 1rem 1rem 0 0;
}
#window #outer-box #input:focus, #window #outer-box #input:focus-visible, #window #outer-box #input:active {
  border: none;
  outline: 2px solid transparent;
  outline-offset: 2px;
}
#window #outer-box #scroll {
  /* The name of the box containing all of the entries */
}
#window #outer-box #scroll #inner-box {
  /* The name of all entries */
  /* The name of all boxes shown when expanding  */
  /* entries with multiple actions */
}
#window #outer-box #scroll #inner-box #entry {
  color: #${palette.base05};
  background-color: #${palette.base02};
  padding: 0.6rem 1rem;
  /* The name of all images in entries displayed in image mode */
  /* The name of all the text in entries */
}
#window #outer-box #scroll #inner-box #entry #img {
  width: 1rem;
  margin-right: 0.5rem;
}
#window #outer-box #scroll #inner-box #entry:selected {
  color: #${palette.base00};
  background-color: #${palette.base01};
  outline: none;
};
  '';
  };
}
