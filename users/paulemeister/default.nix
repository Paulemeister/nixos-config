{ ... }:
{
  imports = [ ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.paulemeister = {
    isNormalUser = true;
    description = "Paulemeister";
    extraGroups = [
      "networkmanager"
      "dialout" # tilp
      "wheel"
      "vboxusers"
      "plugdev"
      "input"
      "audio"
      "i2c"
    ];
    hashedPasswordFile = "/persist/passwords/paulemeister";
  };

  home-manager.users.paulemeister = import ./home.nix;

}
