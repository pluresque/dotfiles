{ pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays =
      let
        path = ../../overlays;
      in
      with builtins;
      map (n: import (path + ("/" + n)))
        (filter
          (n:
            match ".*\\.nix" n != null
            || pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)));
  };

  nix.optimise.automatic = true;

  programs.zsh.enable = true;

  environment.variables.EDITOR = "nvim";

  environment.shells = [ pkgs.zsh ];
}
