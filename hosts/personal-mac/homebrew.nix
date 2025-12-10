{ config, pkgs, ... }:

{
  # Host-specific homebrew packages for personal-mac
  homebrew = {
    casks = [
      "calibre"
    ];
  };
}
