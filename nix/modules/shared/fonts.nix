{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      material-design-icons
      font-awesome
      nerd-fonts.jetbrains-mono
    ];
  };
}
