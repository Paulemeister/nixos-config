{
  description = "Paulemeisters Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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

    pdfcat = {
      url = "github:paulemeister/pdfcat-nix";
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
    nixos-hardware.url = "github:NixOs/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      # nixpkgs-unstable,
      # nixpkgs-master,
      # chaotic,
      # home-manager,
      # stylix,
      # impermanence,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      # pkgs-unstable = import nixpkgs-unstable {
      #   inherit system;
      #   config.allowUnfree = true;
      # };
      # pkgs-master = import nixpkgs-master {
      #   inherit system;
      #   config.allowUnfree = true;
      # };
      # pkgs-chaotic = chaotic.legacyPackages.${system};
    in
    {
      nixpkgs.config.allowUnfree = true;
      nixosConfigurations = {
        theseus = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              outputs
              self
              # pkgs-unstable
              # pkgs-master
              # pkgs-chaotic
              ;
          };

          modules = [
            ./hosts/theseus/configuration.nix
          ];
        };
        nothung = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              outputs
              self
              # pkgs-unstable
              # pkgs-master
              # pkgs-chaotic
              ;
          };

          modules = [
            ./hosts/nothung/configuration.nix
          ];
        };
      };
    };
}
