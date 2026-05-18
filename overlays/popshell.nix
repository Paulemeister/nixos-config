# https://github.com/NixOS/nixprev/issues/256889
# Fix for Pop Shell floating window exceptions and color dialog
# Issue: Missing GTK 3.0 typelib causes dialogs to fail
# See: https://github.com/NixOS/nixprev/issues/256889

(final: prev: {
  gnomeExtensions = prev.gnomeExtensions // {
    pop-shell = prev.gnomeExtensions.pop-shell.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
        prev.gtk3
      ];

      postPatch = (oldAttrs.postPatch or "") + ''
        # Ensure GTK3 typelib is available for dialog scripts
        export GI_TYPELIB_PATH="${prev.gtk3}/lib/girepository-1.0:$GI_TYPELIB_PATH"
      '';

      # Create wrapper scripts for dialog executables
      postInstall = (oldAttrs.postInstall or "") + ''
                    # Create wrapper for color_dialog
                    if [ -f "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js" ]; then
                      mv "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js" \
                         "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js.orig"
                      cat > "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js" << 'EOF'
        #!/usr/bin/env bash
        export GI_TYPELIB_PATH="${prev.gtk3}/lib/girepository-1.0:$GI_TYPELIB_PATH"
        exec ${prev.gjs}/bin/gjs -m "$(dirname "$0")/main.js.orig" "$@"
        EOF
                      chmod +x "$out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js"
                    fi
                    
                    # Create wrapper for floating_exceptions
                    if [ -f "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js" ]; then
                      mv "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js" \
                         "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js.orig"
                      cat > "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js" << 'EOF'
        #!/usr/bin/env bash
        export GI_TYPELIB_PATH="${prev.gtk3}/lib/girepository-1.0:$GI_TYPELIB_PATH"
        exec ${prev.gjs}/bin/gjs -m "$(dirname "$0")/main.js.orig" "$@"
        EOF
                      chmod +x "$out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js"
                    fi
      '';

      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
        prev.makeWrapper
      ];
    });
  };
})
