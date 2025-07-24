{ pkgs, user, ... }:

{
  # Personal Mac Dock Configuration - persistent apps only
  system.defaults.dock.persistent-apps = [
    "${pkgs.forklift}/Applications/ForkLift.app"
    "${pkgs.wezterm}/Applications/WezTerm.app"
    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"
    "${pkgs.chatgpt}/Applications/ChatGPT.app"
    "/Applications/Claude.app"
    "${pkgs.bruno}/Applications/Bruno.app/"
    "${pkgs.obsidian}/Applications/Obsidian.app"
    "${pkgs.spotify}/Applications/Spotify.app"
    "/System/Applications/Reminders.app"
    "/System/Applications/Calendar.app"
    # Add personal-specific apps here
  ];
}
