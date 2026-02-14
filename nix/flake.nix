{
  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable?shallow=true";

    home-manager = {
      url = "github:nix-community/home-manager?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko?shallow=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay?shallow=true";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    agenix,
    disko,
    ...
  }: let
    useremail = "daniilfedotov@protonmail.com";

    linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
    darwinSystems = [ "aarch64-darwin" ];
    allSystems = linuxSystems ++ darwinSystems;
    forAllSystems = f: nixpkgs.lib.genAttrs allSystems f;

    mkApp = scriptName: system: {
      type = "app";
      program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
        #!/usr/bin/env bash
        PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
        echo "Running ${scriptName} for ${system}"
        exec ${self}/apps/${system}/${scriptName} "$@"
      '')}/bin/${scriptName}";
    };

    mkDarwinApps = system: {
      "apply" = mkApp "apply" system;
      "build-switch" = mkApp "build-switch" system;
      "clean" = mkApp "clean" system;
      "rollback" = mkApp "rollback" system;
    };

    mkLinuxApps = system: {
      "apply" = mkApp "apply" system;
      "build-switch" = mkApp "build-switch" system;
      "clean" = mkApp "clean" system;
      "create-keys" = mkApp "create-keys" system;
      "copy-keys" = mkApp "copy-keys" system;
    };
  in {
    darwinConfigurations.pluresque = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = inputs // {
        username = "apple";
        inherit useremail;
      };
      modules = [
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = inputs // {
            username = "apple";
            inherit useremail;
          };
        }
        ./hosts/darwin
      ];
    };

    nixosConfigurations.pluresque-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs // {
        username = "pluresque";
        inherit useremail;
      };
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = inputs // {
            username = "pluresque";
            inherit useremail;
          };
        }
        ./hosts/nixos/pluresque-desktop
        ./modules/nixos/home-manager.nix
      ];
    };

    nixosConfigurations.pluresque-homelab = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = inputs // {
        username = "pluresque";
        inherit useremail;
      };
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = inputs // {
            username = "pluresque";
            inherit useremail;
          };
        }
        ./hosts/nixos/pluresque-homelab
        ./modules/nixos/home-manager.nix
      ];
    };

    apps = nixpkgs.lib.genAttrs darwinSystems mkDarwinApps
        // nixpkgs.lib.genAttrs linuxSystems mkLinuxApps;

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
