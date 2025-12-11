{
  description = "Paulemeisters Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      # url = "github:nix-community/stylix/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sidewinderd = {
      url = "github:paulemeister/sidewinderd-nix";
      # url = "path:/persist/home/paulemeister/Code/sidewinderd-nix"; # for local developement
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprcorners = {
      url = "github:paulemeister/hyprcorners-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # url = "github:nix-community/home-manager/";
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

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      chaotic,
      home-manager,
      stylix,
      sidewinderd,
      impermanence,
      cosmic-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-chaotic = chaotic.legacyPackages.${system};
    in
    {
      nixpkgs.config.allowUnfree = true;
      nixosConfigurations = {
        theseus = nixpkgs.lib.nixosSystem rec {
          inherit system;

          specialArgs = {
            inherit
              inputs
              outputs
              pkgs-unstable
              pkgs-chaotic
              ;
          };

          modules = [
            ./nixos/hardware-configuration.nix
            ./nixos/configuration.nix
            chaotic.nixosModules.nyx-cache
            # chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            stylix.nixosModules.stylix
            ./overlays/kgx-stylix-patch.nix
            impermanence.nixosModules.impermanence
            sidewinderd.nixosModules.sidewinderd
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".bak";

              home-manager.users.paulemeister = import ./home-manager/paulemeister.nix;

              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };
    };
}
