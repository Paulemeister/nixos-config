{ self, inputs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    "${self}/overlays/kgx-stylix-patch.nix"
    inputs.impermanence.nixosModules.impermanence
    "${self}/users/common"
    "${self}/nixos-modules"
  ];
}
