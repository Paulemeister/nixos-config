{pkgs, ...}: {
  home.packages = with pkgs; [
    nvtopPackages.amd
    sd
  ];
  programs = {
    bat.enable = true;
    fd.enable = true;
  };
}
