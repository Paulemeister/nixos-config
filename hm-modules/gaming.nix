{ pkgs, lib, ... }:
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
    };
  };

  stylix.targets.mangohud = {
    fonts.enable = false;
    opacity.enable = false;
  };
}
