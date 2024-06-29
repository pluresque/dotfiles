{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Languages
    python312
    python312Packages.virtualenv
    go
    rustup
    nodejs
    nodePackages.prettier
    nodePackages.npm
    lua

    # Tools
    git
    fzf # Fuzzy finder
    zoxide # Better cd
    eza # Better ls
    yt-dlp # Download videos
    ripgrep 
    fd
    just
    tldr
    yazi
    pipx
    mpv
    zip
    unzip
    wget

    # DevOps
    terraform
    ansible
    kubectl
    kubernetes-helm
    minikube
    docker
    
    # GUI apps
    spotify
    obsidian
    wezterm
    zathura
  ];

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
