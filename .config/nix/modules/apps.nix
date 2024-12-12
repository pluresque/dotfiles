{ pkgs, ... }: {
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  environment.variables.EDITOR = "nvim";
}
