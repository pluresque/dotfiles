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

    stateVersion = "24.11";

    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;
}
