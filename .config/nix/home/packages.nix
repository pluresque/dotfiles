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
    nodePackages.npm
    nodePackages.yarn

    # LSPs, Linters & Formatters
    ruff
    pyright
    typescript-language-server
    lua-language-server
    hadolint
    omnisharp-roslyn
    yaml-language-server
    phpactor
    nodePackages.prettier
    nodePackages.eslint

    # Editors
    unstable.neovim

    # Terminal utils
    eza # Better ls
    zoxide # Better cd
    fd # Better find
    fzf # Fuzzy finder
    bat # Modern cat
    ripgrep
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
    qemu
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
    packer
    talosctl
    postgresql_17
    zola

    # Networking
    curl
    wget
    nmap
    tcpdump

    # Media
    mpv
    ffmpeg
    imagemagick

    # System monitoring
    smartmontools

  ];
}
