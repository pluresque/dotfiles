{ pkgs, ... }: {
  programs.zsh.enable = true;

  environment.variables.EDITOR = "nvim";
}
