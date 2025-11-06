{pkgs, ...}: {
  home.packages = with pkgs; [
    nvtopPackages.amd
    sd
    killall
  ];
  programs = {
    bat.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
  };
}
