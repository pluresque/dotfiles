{
  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    nixpkgs-unstable,
    ...
  }: let
    username = "apple";
    useremail = "daniilfedotov@protonmail.com";
    system = "aarch64-darwin";
    hostname = "pluresque";

    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
      (final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${system};
      })
    ];

    specialArgs =
      inputs
      // {
        inherit username useremail hostname;
      };
  in {

    darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        ./darwin/system.nix
        ./darwin/homebrew.nix
        ./modules/nix-core.nix
        ./modules/apps.nix
        ./modules/fonts.nix
        ./modules/host-users.nix
        home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = overlays;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
