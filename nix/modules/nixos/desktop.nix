{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # PipeWire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Ghostty terminal
  environment.systemPackages = with pkgs; [
    ghostty
    grim
    slurp
    wl-clipboard
    brightnessctl
    playerctl
    pavucontrol
    wofi
  ];
}
