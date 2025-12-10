{ config, pkgs, lib, ... }: 

{
  programs.lsd = {
    enable = true;
  };

  catppuccin.lsd.enable = true;
}
