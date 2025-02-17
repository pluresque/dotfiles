{ ... }: {

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    masApps = {
      # Xcode = 497799835;
      Telegram = 747648890;
      Klack = 6446206067;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
    ];

    brews = [
      "texlive"
    ];

    casks = [
      "raycast" "tomatobar" "iina" "amethyst"
    ];
  };

}
