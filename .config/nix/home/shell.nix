{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initExtra = ''
      PROMPT=' %B%F{240}λ%f%b '
      RPROMPT='%F{blue}%~%f'
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source <(fzf --zsh)
    '';
  };
  
  home.shellAliases = {
    k = "kubectl";
    v = "nvim";
    d = "docker";
    ls = "eza --long";
    python = "python3";
    nixswitch = "darwin-rebuild switch --flake ~/.config/nix/.#";
    nixclean = "nix-env --delete-generations old";
    cd = "z";
    cdi = "zi";
    neofetch = "fastfetch";
  };
}
