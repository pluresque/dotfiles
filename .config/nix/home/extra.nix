{ pkgs, ... }:

{
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    # zellij = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };

  tmux = {
    enable = true;
    package = pkgs.tmux;

    baseIndex = 1;
    clock24 = true;
    mouse = true;
    newSession = true;

    shell = "${pkgs.zsh}/bin/zsh";

    plugins = with pkgs;
      [
        tmuxPlugins.better-mouse-mode
      ];

    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      set-option -g history-limit 10000
      set-option -g status-interval 5
      set-option -g status-position bottom
      set-option -g status-style bg=colour234,fg=colour247
      set-option -g allow-rename off

      # Split panes easier
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Enable true color
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

# don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

# clock mode
setw -g clock-mode-colour yellow

# copy mode
setw -g mode-style 'fg=black bg=red bold'

# panes
set -g pane-border-style 'fg=red'
set -g pane-active-border-style 'fg=yellow'

# statusbar
set -g status-position bottom
set -g status-justify left
set -g status-style 'fg=red'

set -g status-left-length 10

set -g status-right-style 'fg=black bg=yellow'
set -g status-right '%Y-%m-%d %H:%M '
set -g status-right-length 50

setw -g window-status-current-style 'fg=black bg=red'
setw -g window-status-current-format ' #I #W #F '

setw -g window-status-style 'fg=red bg=black'
setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

setw -g window-status-bell-style 'fg=yellow bg=red bold'

# messages
set -g message-style 'fg=yellow bg=red bold'

bind-key -n -N 'Toggle popup window' M-3 if-shell -F '#{==:#{session_name},popup}' {
    detach-client
} {
    display-popup -d "#{pane_current_path}" -xC -yC -w 80% -h 75% -E 'tmux attach-session -t popup || tmux new-session -s popup'
}
    '';
  };

    fastfetch = {
      enable = true;
      settings =
        {
          logo = {
            source = "nixos_small";
            padding = {
              right = 1;
            };
          };
          display = {
            size.binaryPrefix = "si";
            color = "blue";
            separator = ": ";
          };
          modules = [
            {
              type = "custom";
              key = "System";
              format = "macOS";
            }
            "memory"
            "packages"
            "uptime"
            "terminal"
            "break"
            "player"
            "media"
          ];
        };
      };
  };
}
