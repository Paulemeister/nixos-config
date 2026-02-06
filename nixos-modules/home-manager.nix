{
  self,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = ".bak";

  home-manager.extraSpecialArgs = {
    inherit
      inputs
      outputs
      self
      ;
  };
}
