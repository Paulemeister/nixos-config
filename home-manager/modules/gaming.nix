{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
  ];

  home.persistence."/persist".directories = [
    {
      directory = ".local/share/Steam";
      # method = "symlink";
    }
  ];
  programs = {
    mangohud = {
      enable = true;
      # enableSessionWide = true;
    };
  };
}
