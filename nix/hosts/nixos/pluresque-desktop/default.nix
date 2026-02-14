{
  agenix,
  username,
  pkgs,
  ...
}:
{
  imports = [
    ../../../modules/shared
    ../../../modules/shared/fonts.nix
    ../../../modules/nixos/desktop.nix
    ../../../modules/nixos/packages.nix
    ../../../modules/nixos/disk-config.nix
    ../../../modules/nixos/secrets.nix
    agenix.nixosModules.default
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];

  # Hardware
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Networking
  networking.hostName = "pluresque-desktop";
  networking.networkmanager.enable = true;

  # Timezone & Locale
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
    ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ username ];

  # GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # SSH
  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
