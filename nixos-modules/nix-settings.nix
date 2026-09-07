{
  pkgs,
  ...
}:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    trusted-users = [
      "root"
      "paulemeister"
    ];
    # Enable Flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Does this even do anything?
    substituters = [
      "https://cache.nixos.org"
      "https://paulemeister.cachix.org"
    ];
    trusted-public-keys = [
      "paulemeister.cachix.org-1:mL+VLlWr/Nj8/4VfODO4vM4iuzLF6bGOVSShn28WA04="
    ];
  };
  # Enable dynamic linking fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Needed for PyQT matplotlib rendering
    dbus # libdbus-1.so.3
    fontconfig # libfontconfig.so.1
    freetype # libfreetype.so.6
    libGL # libGL.so.1
    libxkbcommon # libxkbcommon.so.0
    libX11 # libX11.so.6
    wayland

    glib # libglib-2.0.so.0
    zstd # libzstd.so.1
  ];

}
