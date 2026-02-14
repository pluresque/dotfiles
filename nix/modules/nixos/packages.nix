{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    wl-clipboard
    wayland-utils
    lm_sensors
    btop
  ];
}
