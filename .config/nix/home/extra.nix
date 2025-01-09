{ pkgs, ... }:

{
  programs = {
    fzf.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
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
              format = "macOS (Nix Darwin)";
            }
            "memory"
            "uptime"
            "terminal"
            "break"
            "player"
            "media"
          ];
        };
      };

    tmux = {
      enable = true;
      # shortcut = "a";
      prefix = "C-a";
      sensibleOnTop = false;
      # aggressiveResize = true; -- Disabled to be iTerm-friendly
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;

      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''
        set -gu default-command
        set -g default-shell "$SHELL"

        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
    };


  };
}
