{ pkgs, ... }:

{
  programs = {
    fzf.enable = true;

    # ghostty = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   clearDefaultKeybinds = true;
    #   installVimSyntax = true;
    #   settings = {
    #     window-decoration =  false;
    #     window-padding-x = 0;
    #     window-padding-y = 0;
    #     theme = "gruvbox-material";
    #     font-feature = "-liga -calt -dlig";
    #   };
    # };

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
  };
}
