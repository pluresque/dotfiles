{ config, nix-index-database, ... }:
{
  imports = [
    ./shell.nix
    ./programs.nix
    ./git.nix
    nix-index-database.homeModules.nix-index
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/dotfiles/nvim";

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.home-manager.enable = true;
}
