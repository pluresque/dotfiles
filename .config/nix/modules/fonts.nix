{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "JetBrainsMono"
        ];
      })
    ];
  };
}
