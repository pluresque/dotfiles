{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Languages
    rustup
    zig
    nodejs
    nodePackages.prettier
    nodePackages.npm
    nodePackages.yarn
    nodePackages.eslint
    python311Full
    dotnetCorePackages.sdk_8_0_3xx

    # Tools
    git
    fzf # Fuzzy finder
    zoxide # Better cd
    eza # Better ls
    yt-dlp
    unstable.neovim
    ripgrep
    fd
    just
    tldr
    mpv
    zip
    unzip
    postgresql_16
    wget
    curl
    exiftool # Metadata viewer
    tree
    ngrok
    ffmpeg
    smartmontools
    zola
    zellij
    ctop
    uv

    # DevOps
    terraform
    ansible
    kubectl
    kubernetes-helm
    minikube
    docker
    colima

    # GUI apps
    wezterm
  ];
}
