{ config, pkgs, lib, inputs, ... }:

{
  # Import config for home-manager programs
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # Define theme options that can accessed via config
  options = {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin";  # Default theme name
      description = "The theme to use for applications and styling.";
    };

    flavor = lib.mkOption {
      type = lib.types.enum [ "latte" "frappe" "macchiato" "mocha" ];
      default = "mocha";  # Default Catppuccin flavor
      description = "The Catppuccin flavor to use.";
    };
  };

  # set catppuccin home-manager flavor (this flavor will be used in all programs that enable catppuccin theme)
  config = {
    catppuccin.flavor = config.flavor;
  };
}
