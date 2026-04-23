{
  self,
  config,
  lib,
  pkgs,
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
    # https://github.com/NixOS/nixpkgs/issues/256889
    {
      # Fix for Pop Shell floating window exceptions and color dialog
      # Issue: Missing GTK 3.0 typelib causes dialogs to fail
      # See: https://github.com/NixOS/nixpkgs/issues/256889

      nixpkgs.overlays = [
        (final: prev: {
          gnomeExtensions = prev.gnomeExtensions // {
            pop-shell = prev.gnomeExtensions.pop-shell.overrideAttrs (oldAttrs: {
              buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
                pkgs.gtk3
              ];

              postPatch = (oldAttrs.postPatch or "") + ''
                # Ensure GTK3 typelib is available for dialog scripts
                export GI_TYPELIB_PATH="${pkgs.gtk3}/lib/girepository-1.0:$GI_TYPELIB_PATH"
              '';

              # Create wrapper scripts for dialog executables
              postInstall = (oldAttrs.postInstall or "") + ''
                            # Create wrapper for color_dialog
                            if [ -f "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js" ]; then
                              mv "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js" \
                                 "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js.orig"
                              cat > "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js" << 'EOF'
                #!/usr/bin/env bash
                export GI_TYPELIB_PATH="${pkgs.gtk3}/lib/girepository-1.0:$GI_TYPELIB_PATH"
                exec ${pkgs.gjs}/bin/gjs -m "$(dirname "$0")/main.js.orig" "$@"
                EOF
                              chmod +x "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js"
                            fi
                            
                            # Create wrapper for floating_exceptions
                            if [ -f "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js" ]; then
                              mv "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js" \
                                 "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js.orig"
                              cat > "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js" << 'EOF'
                #!/usr/bin/env bash
                export GI_TYPELIB_PATH="${pkgs.gtk3}/lib/girepository-1.0:$GI_TYPELIB_PATH"
                exec ${pkgs.gjs}/bin/gjs -m "$(dirname "$0")/main.js.orig" "$@"
                EOF
                              chmod +x "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js"
                            fi
              '';

              nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
                pkgs.makeWrapper
              ];
            });
          };
        })
      ];
    }

  ];
}
