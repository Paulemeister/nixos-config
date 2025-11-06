{pkgs, ...}: {
  home.packages = with pkgs; [
    python312
    godot
    uv
  ];
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium-fhs;
    package = pkgs.vscode-fhs;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # ms-python.python
        # ms-python.vscode-pylance
        # ms-toolsai.jupyter
      ];
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      userSettings = {
        # "python.languageServer" = "Pylance";
        # "jupyter.enableExtendedPythonKernelCompletions" = true;
        "workbench.settings.showAISearchToggle" = false;
        "chat.disableAIFeatures" = true;
      };
    };
  };
}
