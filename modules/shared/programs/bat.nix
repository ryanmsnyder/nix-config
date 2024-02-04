{ config, pkgs, lib, ... }: 

let
  catppuccinThemeSrc = pkgs.fetchFromGitHub {
    # owner = "dracula";
    owner = "catppuccin";
    # repo = "sublime"; # Bat uses sublime syntax for its themes
    repo = "bat";
    # rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    # sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
    sha256 = "1g2r6j33f4zys853i1c5gnwcdbwb6xv5w6pazfdslxf69904lrg9";
  };
in

{
  programs.bat = {
    enable = true;
    config = {
      # Assuming `theme` here is meant to be the name of the theme as recognized by `bat`,
      # not the path to the `.tmTheme` file itself.
      # If `bat` expects a theme name here, ensure this matches the name of the theme
      # as it would appear in `bat --list-themes` after being added.
    #   theme = "Dracula";
      theme = "catppuccin-macchiato";
      pager = "less -FR";
    };

    # The `themes` option expects an attribute set where the value can either be a string
    # (directly the theme content) or a submodule with `src` (and optionally `file`).
    # Since `bat` looks for themes in its configuration directory under `themes/`,
    # the name of the theme file (without path) should match the expected theme name.
    # themes = {
    #   dracula = {
    #     src = draculaThemeSrc;
    #     file = "Dracula.tmTheme"; # Ensure this matches the file name in the source repo
    #   };
    # };

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

#   # Ensure that `bat`'s cache is rebuilt after changes to its configuration or themes.
#   # This step is necessary for `bat` to recognize new or updated themes.
#   home.activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
#     $DRY_RUN_CMD ${config.xdg.configHome}/bat/config/bat cache --build
#   '';
}
