{ pkgs, ... }:

{
  # Work MacBook Pro Dock Configuration - persistent apps only
  system.defaults.dock.persistent-apps = [
    "${pkgs.forklift}/Applications/ForkLift.app"
    "${pkgs.wezterm}/Applications/WezTerm.app"
    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app/"
    "/Applications/Claude.app"
    "${pkgs.bruno}/Applications/Bruno.app/"
    "${pkgs.obsidian}/Applications/Obsidian.app"
    "/System/Applications/Calendar.app"
    "/Applications/Slack.app"
  ];
}
