{
  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin?shallow=true";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=true";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay?shallow=true";
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
