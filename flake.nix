{
  description = "Axels Multi-Host NixOS Flake - Stable 25.11";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      n100-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/n100-nixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      qnixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/qnixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      bnixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/bnixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      qtnixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/qtnixos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
