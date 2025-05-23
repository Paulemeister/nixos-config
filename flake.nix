{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #nix-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    sidewinderd.url = "github:paulemeister/sidewinderd-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    sidewinderd,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixpkgs.config.allowUnfree = true;
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        modules = [
          #./nixos/cosmic.nix
          sidewinderd.nixosModules.sidewinderd
          ./nixos/hardware-configuration.nix
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.paulemeister = import ./home-manager/home.nix;

            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
  };
}
