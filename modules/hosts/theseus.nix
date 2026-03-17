{ inputs, self, ... }:

{
  flake.nixosConfigurations =
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
    in
    {
      theseus = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../hosts/theseus/configuration.nix
          {
            nixpkgs.overlays = [
              inputs.sidewinderd.overlays.default
              inputs.hyprcorners.overlays.default
            ];
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
