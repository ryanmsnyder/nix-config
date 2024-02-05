{ config, pkgs, lib, ... }: 

let
  catppuccinThemeSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "1g2r6j33f4zys853i1c5gnwcdbwb6xv5w6pazfdslxf69904lrg9";
  };
in

{
  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin-macchiato";
      pager = "less -FR";
    };

    themes = {
      catppuccin-macchiato = {
        src = catppuccinThemeSrc;
        file = "Catppuccin-macchiato.tmTheme"; # Ensure this matches the file name in the source repo
      };
      catppuccin-mocha = {
        src = catppuccinThemeSrc;
        file = "Catppuccin-mocha.tmTheme"; # Ensure this matches the file name in the source repo
      };
    };
  };

}
