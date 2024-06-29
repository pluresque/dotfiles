{ pkgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  environment.systemPackages = with pkgs; [
    # Install packages from nix's official package repository.
    # archives
  ];
  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;
  
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas 
    masApps = {
      # Xcode = 497799835;
      Telegram = 747648890;
      Klack = 6446206067; 
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "zegervdv/zathura"
    ];

    brews = [
      "neovim" "curl" "zegervdv/zathura/zathura" "zegervdv/zathura/zathura-pdf-mupdf" "choose-gui"
    ];

    casks = [
      "raycast" "hiddenbar" "tomatobar" "iina" "amethyst" "bitwarden" "arc"
    ];
  };
  
 services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
	# Focus window  
    '';
  };

}
