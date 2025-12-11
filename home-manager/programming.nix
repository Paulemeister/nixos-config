{pkgs, ...}: {
  home.packages = with pkgs; [
    python312
    godot
    uv
  ];
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium-fhs;
    package = pkgs.vscode;
    # package = pkgs.vscode.fhsWithPackages (ps:
    #   with ps; [
    #     zstd
    #     libGL
    #     fontconfig
    #     freetype

    #     libxkbcommon # libxkbcommon.so.0
    #     xorg.libX11 # libX11.so.6
    #     wayland
    #   ]);
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-python.black-formatter
        ms-toolsai.jupyter
      ];
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      userSettings = {
        # "python.languageServer" = "Pylance";
        # "jupyter.enableExtendedPythonKernelCompletions" = true;
        "workbench.settings.showAISearchToggle" = false;
        "chat.disableAIFeatures" = true;
        "explorer.confirmDelete" = false;
      };
    };
  };
}
