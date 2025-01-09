{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Languages
    rustup
    zig
    nodejs
    python312Full
    python312Packages.distutils
    python312Packages.setuptools
    dotnetCorePackages.sdk_8_0_3xx

    # Language packages
    nodePackages.prettier
    nodePackages.npm
    nodePackages.yarn
    nodePackages.eslint
    ruff

    # Editors
    unstable.neovim

    # Terminal utils
    eza # Better ls
    zoxide # Better cd
    fzf # Fuzzy finder
    bat # Modern cat
    ripgrep
    fd
    just # Task runner
    exiftool # Metadata viewer
    tldr # Simplified man pages
    jq # JSON processor
    zip
    unzip
    p7zip
    rsync
    tree
    tmux

    # Downloaders
    gallery-dl
    yt-dlp

    # Development
    git
    uv
    docker
    kubectl
    direnv
    ngrok
    terraform
    ansible
    kubernetes-helm
    minikube
    colima

    # Networking
    wget
    curl
    nmap
    tcpdump

    # Media
    mpv
    ffmpeg

    # System monitoring
    smartmontools

    postgresql_17
    zola
    zellij

    # GUI apps
    wezterm

  ];
}
