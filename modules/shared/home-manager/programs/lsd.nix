{ config, pkgs, lib, ... }: 


{
  programs.lsd = {
    enable = true;
    enableAliases = true;

  };

  catppuccin.lsd.enable = true;
}
