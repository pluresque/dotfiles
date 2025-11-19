{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python312Full
    python312Packages.distutils
    python312Packages.setuptools
    nodejs
    nodePackages.npm
    nodePackages.yarn
    dotnetCorePackages.sdk_8_0_3xx
    rustup
    zig
    deno
    bun

    ruff
    pyright
    typescript-language-server
    lua-language-server
    omnisharp-roslyn
    yaml-language-server
    helm-ls
    gopls
    nodePackages.prettier
    nodePackages.eslint

    # Editors
    neovim

    # Utils
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
    zellij
    cloc
    onefetch
    ncdu
    pfetch

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
    redis
    awscli
    claude-code

    # Networking
    curl
    wget
    nmap
    tcpdump

    # Media
    mpv
    ffmpeg
    imagemagick
    gallery-dl
    yt-dlp

    # System monitoring
    smartmontools
    htop
  ];
}
