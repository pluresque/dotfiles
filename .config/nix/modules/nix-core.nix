{ pkgs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 1d";
  };

  nix.optimise.automatic = true;
}
