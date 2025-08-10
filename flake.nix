{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    sidewinderd = {
      url = "github:paulemeister/sidewinderd-nix";
      #url = "path:/persist/home/paulemeister/Code/sidewinderd-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-chaotic,
    home-manager,
    sidewinderd,
    impermanence,
    cosmic-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-chaotic = nixpkgs-chaotic.legacyPackages.${system};
  in {
    nixpkgs.config.allowUnfree = true;
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      theseus = nixpkgs.lib.nixosSystem rec {
        inherit system;

        specialArgs = {
          inherit inputs outputs pkgs-unstable;
        };

        modules = [
          ./nixos/hardware-configuration.nix
          ./nixos/configuration.nix
          # nixpkgs-chaotic.nixosModules.nyx-cache
          # nixpkgs-chaotic.nixosModules.nyx-registry
          # nixpkgs-chaotic.nixosModules.nyx-overlay
          impermanence.nixosModules.impermanence
          sidewinderd.nixosModules.sidewinderd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.paulemeister = import ./home-manager/paulemeister.nix;

            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
  };
}
