{ ... }:
{

  programs.distrobox = {
    enable = true;
    settings = {
      container_user_custom_home = "$HOME/.local/share/distrobox/$DBX_CONTAINER_NAME";
    };
  };

  home.persistence."/persist".directories = [
    ".local/share/containers"
    ".local/share/distrobox"
  ];
}
