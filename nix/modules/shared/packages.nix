{
  pkgs,
  neovim-nightly-overlay,
  llm-agents,
}:
with pkgs;
[
  python312
  python312Packages.setuptools
  nodejs_22
  dotnetCorePackages.sdk_8_0_4xx
  rustup
  zig
  deno
  bun

  ruff
  typescript-language-server
  lua-language-server
  gopls

  # Editors
  neovim-nightly-overlay.packages.${pkgs.system}.default
  tree-sitter

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

  # AI agents
  llm-agents.packages.${pkgs.system}.claude-code
  llm-agents.packages.${pkgs.system}.codex

  # Development
  git
  gh
  uv
  docker
  kubectl
  direnv
  ngrok
  terraform
  ansible
  kubernetes-helm
  minikube
  packer
  talosctl
  postgresql_17
  redis
  awscli

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
]
