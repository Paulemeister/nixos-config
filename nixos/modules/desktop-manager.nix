{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [ wl-clipboard ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  nixpkgs.overlays = [
    inputs.hyprcorners.overlays.default
  ];
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
    videoDrivers = [ "amdgpu" ];
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-maps
    gnome-clocks
    gnome-contacts
    gnome-calendar
    gnome-software
    gnome-tour
    gnome-weather
    gnome-connections
    gnome-initial-setup
    gnome-logs
    gnome-characters
    gnome-user-docs
    gnome-browser-connector
    gnome-console
    cheese
    epiphany
    geary
    simple-scan
  ];
  # Set account picture
  system.activationScripts.script.text =
    let
      name = "paulemeister";
    in
    ''
      mkdir -p /var/lib/AccountsService/{icons,users}
      cp ${../../home-manager/dotfiles/paulemeister-icon} /var/lib/AccountsService/icons/${name}
      echo -e "[User]\nSession=cosmic\nIcon=/var/lib/AccountsService/icons/${name}\n" > /var/lib/AccountsService/users/${name}

      chown root:root /var/lib/AccountsService/users/${name}
      chmod 0600 /var/lib/AccountsService/users/${name}

      chown root:root /var/lib/AccountsService/icons/${name}
      chmod 0444 /var/lib/AccountsService/icons/${name}
    '';

  # for desktop portals? double check not needed?
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
