{ agenix, username, pkgs, lib, ... }: {
  imports = [
    ../../../modules/shared
    ../../../modules/nixos/packages.nix
    ../../../modules/nixos/disk-config.nix
    ../../../modules/nixos/secrets.nix
    agenix.nixosModules.default
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "pluresque-homelab";
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  # Timezone & Locale
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # Docker & Podman
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  # User
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    description = username;
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ username ];

  # GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # SSH hardened
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "25.05";
}
