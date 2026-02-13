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

      # SSH with terminal coloring per environment
      ssh() {
        case "$1" in
          prod|production)
            printf '\033]11;#3d1515\007'
            command ssh "$@"
            printf '\033]11;#1a1b26\007'
            ;;
          staging)
            printf '\033]11;#3d2915\007'
            command ssh "$@"
            printf '\033]11;#1a1b26\007'
            ;;
          *)
            command ssh "$@"
            ;;
        esac
      }
    '';
  };

  home.shellAliases = {
    k = "kubectl";
    v = "nvim";
    vim = "nvim";
    ls = "eza --long";
    python = "python3";
    neofetch = "fastfetch";
  };
}
