{pkgs, ...}: {
  home.packages = with pkgs; [
    nvtopPackages.amd
    sd
    killall
    fastfetch
    tlrc
  ];
  programs = {
    bat.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    yazi.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = false;
      };
    };
  };
}
