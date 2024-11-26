{ pkgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################
  
  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    # Install packages from nix's official package repository.
    # archives
  ];
  environment.variables.EDITOR = "nvim";
}
