{ ... }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    masApps = {
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
