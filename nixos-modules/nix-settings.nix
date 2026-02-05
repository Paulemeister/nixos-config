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
    # Does this even do anything? lan-mouse rebuilds anyway
    substituters = [
      "https://lan-mouse.cachix.org/"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "lan-mouse.cachix.org-1:KlE2AEZUgkzNKM7BIzMQo8w9yJYqUpor1CAUNRY6OyM="
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
    xorg.libX11 # libX11.so.6
    wayland

    glib # libglib-2.0.so.0
    zstd # libzstd.so.1
  ];

}
