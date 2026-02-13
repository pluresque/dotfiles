{ username, pkgs, neovim-nightly-overlay, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = { ... }: {
      imports = [ ../shared/home-manager.nix ];
      home = {
        username = username;
        homeDirectory = "/Users/${username}";
        stateVersion = "25.05";
        packages = (import ../shared/packages.nix { inherit pkgs neovim-nightly-overlay; }) ++ (with pkgs; [ colima ]);
      };
    };
  };
}
