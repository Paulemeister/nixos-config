{
  self,
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
  username = "paulemeister";
in
{
  imports = [ ];

  # Set account picture
  config = mkMerge [
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${username} = {
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
    (mkIf cfg.gui {
      system.activationScripts.script.text = ''
        mkdir -p /var/lib/AccountsService/{icons,users}
        cp ${self}/misc/configfiles/paulemeister-icon /var/lib/AccountsService/icons/${username}
        echo -e "[User]\nSession=${cfg.de.default}\nIcon=/var/lib/AccountsService/icons/${username}\n" > /var/lib/AccountsService/users/${username}

        chown root:root /var/lib/AccountsService/users/${username}
        chmod 0600 /var/lib/AccountsService/users/${username}

        chown root:root /var/lib/AccountsService/icons/${username}
        chmod 0444 /var/lib/AccountsService/icons/${username}
      '';
    })
  ];
}
