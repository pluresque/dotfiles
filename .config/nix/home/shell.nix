{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initContent = ''
      PROMPT=' %B%F{240}λ%f%b '
      RPROMPT='%F{blue}%~%f'
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source <(fzf --zsh)
    '';
  };
  
  home.shellAliases = {
    k = "kubectl";
    v = "nvim";
    vim = "nvim";
    ls = "eza --long";
    python = "python3";
    cd = "z";
    cdi = "zi";
    neofetch = "fastfetch";
  };
}
