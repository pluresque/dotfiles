{ username, ... }:

{
  imports = [
    ./shell.nix
    ./extra.nix
    ./git.nix
    ./packages.nix
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    stateVersion = "25.05";

    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
