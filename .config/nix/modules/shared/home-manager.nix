{ username, ... }: {
  imports = [
    ./shell.nix
    ./programs.nix
    ./git.nix
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
