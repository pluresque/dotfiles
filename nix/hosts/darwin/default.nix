{ agenix, username, ... }: {
  imports = [
    ../../modules/shared
    ../../modules/shared/fonts.nix
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/secrets.nix
    agenix.darwinModules.default
  ];

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
    options = "--delete-older-than 1d";
  };

  networking.hostName = "pluresque";
  networking.computerName = "pluresque";
  system.defaults.smb.NetBIOSName = "pluresque";

  users.users.${username} = {
    home = "/Users/${username}";
    description = username;
  };

  nix.settings.trusted-users = [ username ];
}
