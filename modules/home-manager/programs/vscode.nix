{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      extensions = (with pkgs.vscode-extensions; [
        aaron-bond.better-comments
        bbenoist.nix
        catppuccin.catppuccin-vsc
        esbenp.prettier-vscode
        formulahendry.auto-rename-tag
        github.vscode-pull-request-github
        hediet.vscode-drawio
        mishkinf.goto-next-previous-member
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        naumovs.color-highlight
        redhat.vscode-yaml
        tamasfe.even-better-toml
        vscode-icons-team.vscode-icons
        yzhang.markdown-all-in-one
      ]) ++ (with pkgs.vscode-marketplace; [
        albert.tabout
        anthropic.claude-code
        dnicolson.binary-plist
        ms-python.vscode-python-envs
        techer.open-in-browser
        yechunan.json-color-token
      ]);

      userSettings = {
        "update.mode" = "none";
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;
        "telemetry.telemetryLevel" = "off";
        "workbench.colorTheme" = "Catppuccin Macchiato";
      };
    };
  };
}
