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
    	ctrl + alt - h : yabai -m window --focus west
    	ctrl + alt - j : yabai -m window --focus south
    	ctrl + alt - k : yabai -m window --focus north
    	ctrl + alt - l : yabai -m window --focus east

    	# Fill space with window
    	ctrl + alt - 0 : yabai -m window --grid 1:1:0:0:1:1

    	# Move window
    	ctrl + alt - e : yabai -m window --display 1; yabai -m display --focus 1
    	ctrl + alt - d : yabai -m window --display 2; yabai -m display --focus 2
    	ctrl + alt - f : yabai -m window --space next; yabai -m space --focus next
    	ctrl + alt - s : yabai -m window --space prev; yabai -m space --focus prev

    	# Close current window
    	ctrl + alt - w : $(yabai -m window $(yabai -m query --windows --window | jq -re ".id") --close)

    	# Rotate tree
    	ctrl + alt - r : yabai -m space --rotate 90

    	# Open application
    	ctrl + alt - enter : alacritty
    	ctrl + alt - e : emacs
    	ctrl + alt - b : open -a Safari

        ctrl + alt - t : yabai -m window --toggle float;\
          yabai -m window --grid 4:4:1:1:2:2

        ctrl + alt - p : yabai -m window --toggle sticky;\
          yabai -m window --toggle topmost;\
          yabai -m window --toggle pip
    '';
  };

}
