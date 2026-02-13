{ config, username, ... }: {
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

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/Code/dotfiles/nvim";

  programs.home-manager.enable = true;
}
