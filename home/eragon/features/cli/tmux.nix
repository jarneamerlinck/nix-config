{ pkgs, ... }:
let
  plugin-version = "unstable-2023-01-06";
  tmux-nvim = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux.nvim";
      version = "${plugin-version}";
      src = pkgs.fetchFromGitHub {
        owner = "aserowy";
        repo = "tmux.nvim/";
        rev = "65ee9d6e6308afcd7d602e1320f727c5be63a947";
        sha256 = "sha256-zpg7XJky7PRa5sC7sPRsU2ZOjj0wcepITLAelPjEkSI=";
      };
    };
  tmux-browser = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-browser";
      version = "${plugin-version}";
      src = pkgs.fetchFromGitHub {
        owner = "ofirgall";
        repo = "tmux-browser";
        rev = "c3e115f9ebc5ec6646d563abccc6cf89a0feadb8";
        sha256 = "sha256-ngYZDzXjm4Ne0yO6pI+C2uGO/zFDptdcpkL847P+HCI=";
      };
    };

  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "${plugin-version}";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
        sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
      };
    };


in
{
  # TODO: what if this is defined in another file? Merge it!

  home.packages = with pkgs; [
    lsof
  ];

  home = {
    shellAliases = {
      t="tmux";
    };
  };
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs;
      [
        tmux-nvim
        tmuxPlugins.tmux-thumbs
        # TODO: why do I have to manually set this
        {
          plugin = tmux-super-fingers;
          extraConfig = "set -g @super-fingers-key f";
        }
        {
          plugin = tmux-browser;
          extraConfig = ''
            set -g @browser_close_on_deattach '1'
          '';
        }

        tmuxPlugins.sensible
        # must be before continuum edits right status bar
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.yank
      ];
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g mouse on

      # Change splits to match nvim and easier to remember
      # Open new split at cwd of current split
      unbind %
      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Use vim keybindings in copy mode
      set-window-option -g mode-keys vi

      # v in copy mode starts making selection
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Escape turns on copy mode
      bind Escape copy-mode

      # Easier reload of config
      bind r source-file ~/.config/tmux/tmux.conf

      set-option -g status-position top

      # make Prefix p paste the buffer.
      unbind p
      bind p paste-buffer

      # Bind Keys
      bind-key -T prefix C-g split-window \
        "$SHELL --login -i -c 'navi --print | head -c -1 | tmux load-buffer -b tmp - ; tmux paste-buffer -p -t {last} -b tmp -d'"
      bind-key -T prefix C-l switch -t notes
      bind-key -T prefix C-d switch -t dotfiles
      bind-key e send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter
    '';
  };
}
