self: super: {
  mypkgs =
    let
      packagesDir = ../packages;

      # 1. Read the contents of the directory
      dirContents = builtins.readDir packagesDir;

      # 2. Convert directory contents into a clean attribute set of packages
      packageEntries = super.lib.mapAttrs' (
        name: type:
        let
          # Strip '.nix' if it exists so the attribute is pkgs.mypkgs.qss, not qss.nix
          hasNixSuffix = super.lib.hasSuffix ".nix" name;
          cleanName = if hasNixSuffix then super.lib.removeSuffix ".nix" name else name;
        in
        {
          name = cleanName;
          value = self.callPackage (packagesDir + "/${name}") { };
        }
      ) dirContents;
    in
    packageEntries;
}
