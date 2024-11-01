{
  config,
  pkgs,
  ...
}: let
  c = config.colorscheme.palette;
in {
  home.packages = with pkgs; [vesktop];

  xdg.configFile."vesktop/themes/midnight.css".text =
    /*
    css
    */
    ''
@import url('https://refact0r.github.io/midnight-discord/midnight.css');

  /* customize things here */
  :root {
      /* font, change to 'gg sans' for default discord font */
      --font: 'cosmic_text';

      /* top left corner text */
      --corner-text: 'Nord';

      /* color of status indicators and window controls */
      --online-indicator: #${c.base0A}; /* change to #23a55a for default green */
      --dnd-indicator: #${c.base0B}; /* change to #f13f43 for default red */
      --idle-indicator: #${c.base0C}; /* change to #f0b232 for default yellow */
      --streaming-indicator: #${c.base0D}; /* change to #593695 for default purple */

      /* accent colors */
      --accent-1: hsl(179, 25%, 65%); /* links */
      --accent-2: hsl(193, 43%, 67%); /* general unread/mention elements */
      --accent-3: hsl(193, 43%, 67%); /* accent buttons */
      --accent-4: hsl(193, 37%, 60%); /* accent buttons when hovered */
      --accent-5: hsl(193, 31%, 53%); /* accent buttons when clicked */
      --mention: hsla(193, 43%, 51%, 0.1); /* mentions & mention messages */
      --mention-hover: hsla(193, 43%, 51%, 0.05); /* mentions & mention messages when hovered */

      /* text colors */
      --text-0: #${c.base04}; /* text on colored elements */
      --text-1: #${c.base05}; /* other normally white text */
      --text-2: #${c.base04}; /* headings and important text */
      --text-3: #${c.base05}; /* normal text */
      --text-4: #${c.base05}; /* icon buttons and channels */
      --text-5: #${c.base04}; /* muted channels/chats and timestamps */

      /* background and dark colors */
      --bg-1: #${c.base01}; /* dark buttons when clicked */
      --bg-2: #${c.base02}; /* dark buttons */
      --bg-3: #${c.base00}; /* spacing, secondary elements */
      --bg-4: #${c.base01}; /* main background color */
      --hover: hsla(220, 17%, 32%, 0.3); /* buttons when hovered */
      --active: hsla(220, 17%, 32%, 0.5); /* channels and buttons when clicked or selected */
      --message-hover: hsla(0, 0%, 19%, 1); /* messages when hovered */

      /* amount of spacing and padding */
      --spacing: 25px;

      /* animations */
      /* ALL ANIMATIONS CAN BE DISABLED WITH REDUCED MOTION IN DISCORD SETTINGS */
      --list-item-transition: 0.2s ease; /* channels/members/settings hover transition */
      --unread-bar-transition: 0.2s ease; /* unread bar moving into view transition */
      --moon-spin-transition: 0.4s ease; /* moon icon spin */
      --icon-spin-transition: 1s ease; /* round icon button spin (settings, emoji, etc.) */

      /* corner roundness (border-radius) */
      --roundness-xl: 8px; /* roundness of big panel outer corners */
      --roundness-l: 8px; /* popout panels */
      --roundness-m: 8px; /* smaller panels, images, embeds */
      --roundness-s: 8px; /* members, settings inputs */
      --roundness-xs: 8px; /* channels, buttons */
      --roundness-xxs: 8px; /* searchbar, small elements */

      /* direct messages moon icon */
      /* change to block to show, none to hide */
      --discord-icon: none; /* discord icon */
      --moon-icon: block; /* moon icon */
      # --moon-icon-url: url('https://upload.wikimedia.org/wikipedia/commons/3/35/Nix_Snowflake_Logo.svg'); /* custom icon url */
      --moon-icon-size: auto;

      /* filter uncolorable elements to fit theme */
      /* (just set to none, they're too much work to configure) */
      --login-bg-filter: none; /* login background artwork */
      --green-to-accent-3-filter: none; /* add friend page explore icon */
      --blurple-to-accent-3-filter: none; /* add friend page school icon */
  }
    '';
}
