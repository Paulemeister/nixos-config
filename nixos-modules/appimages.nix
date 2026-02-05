{ pkgs, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.openssl
        pkgs.openssl_1_1

      ];
    };
  };
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
}
