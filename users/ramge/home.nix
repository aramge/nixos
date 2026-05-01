{ pkgs, osConfig, config, ... }:

let
  dotfiles = "/home/ramge/sync/gh/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.stateVersion = "25.11";

  programs.waybar.enable = true;
  
  programs.rofi = {
    enable = true;
    # Hinweis: Falls Rofi unter Niri nicht startet, hier pkgs.rofi-wayland eintragen
    package = pkgs.rofi;
  };

  home.file = {
    ".config/ghostty".source = link "${dotfiles}/ghostty/.config/ghostty";
    ".zshenv".source = link "${dotfiles}/zsh/.zshenv";
    ".config/zsh".source = link "${dotfiles}/zsh/.config/zsh";
    ".config/emacs/init.el".source = link "${dotfiles}/emacs/.config/emacs/init.el";
    ".config/niri".source = link "${dotfiles}/niri/.config/niri";
    ".config/git".source = link "${dotfiles}/git/.config/git";
    ".config/tmux".source = link "${dotfiles}/tmux/.config/tmux";
    ".config/waybar".source = link "${dotfiles}/waybar/.config/waybar";
    ".config/foot".source = link "${dotfiles}/foot/.config/foot";
    # Die restlichen Links kannst du später ergänzen, wenn das Bild steht!
  };
}
