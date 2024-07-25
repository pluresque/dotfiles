{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Languages
    go
    rustup
    nodejs
    nodePackages.prettier
    nodePackages.npm
    yarn
    lua
    python311Full
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
    curl
    exiftool
    tree
    ngrok

    # DevOps
    terraform
    ansible
    kubectl
    kubernetes-helm
    minikube
    docker
    docker-compose
    colima

    # GUI apps
    spotify
    obsidian
    wezterm
    zathura
  ];
}
