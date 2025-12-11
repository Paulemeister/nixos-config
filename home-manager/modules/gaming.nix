{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
  ];

  home.persistence."/persist/home/paulemeister".directories= [
    {
          directory = ".local/share/Steam";
          method = "symlink";
        }
  ];
  programs = {
    mangohud = {
      enable = true;
      # enableSessionWide = true;
    };
  };
}
