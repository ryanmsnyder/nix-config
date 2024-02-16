{ pkgs }:

with pkgs;

let 
  sharedPackagesSet = import ../../shared/packages.nix { inherit pkgs; };
  sharedCommandLinePackages = sharedPackagesSet.shared-command-line-pkgs;
  sharedGuiPackages = sharedPackagesSet.shared-gui-pkgs;
  sharedNixOSPackages = sharedPackagesSet.shared-nixos-pkgs;
in
sharedCommandLinePackages ++ sharedGuiPackages ++ sharedNixOSPackages ++ [

  # Security and authentication
  yubikey-manager-qt
  keepassxc

  # Media and design tools
  vlc
  font-manager
  galculator

  # Browsers
  google-chrome

  # Screenshot and recording tools
  flameshot
  simplescreenrecorder

  # Text and terminal utilities
  feh # Manage wallpapers
  screenkey
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # File and system utilities
  i3lock-fancy-rapid
  pcmanfm # Our file browser

  # Other utilities
  yad # I use yad-calendar with polybar

  # PDF viewer
  zathura

  # Music and entertainment
  spotify
]
