{ pkgs, osConfig, config, ... }:
let
  dotfiles = "/home/ramge/sync/gh/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ramge@${osConfig.networking.hostName}";
        email = "axel@ramge.de";
      };
      init.defaultBranch = "main";
    };
  };

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "de"
            }
        }
    }

    layout {
        focus-ring { off; }
        border {
            width 2
            active-color "#74c7ec"
            inactive-color "#313244"
        }
    }

    spawn-at-startup "waybar"

    binds {
//        Mod+Return { spawn "ghostty"; }
        Mod+Return { spawn "foot"; }
        Mod+D      { spawn "rofi" "-show" "drun"; }
        Mod+Q      { close-window; }
        Mod+Shift+E { quit; }

        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+F { maximize-column; }
    }
  '';

  programs.waybar.enable = true;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  home.file = {
    ".config/ghostty".source = link "${dotfiles}/ghostty/.config/ghostty";
    ".config/zsh".source = link "${dotfiles}/zsh/.config/zsh";
    # Die restlichen Links kannst du später ergänzen, wenn das Bild steht!
  };
}
