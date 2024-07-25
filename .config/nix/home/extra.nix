{ ... }:

{
  programs = {
    zoxide = {
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
            binaryPrefix = "si";
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
