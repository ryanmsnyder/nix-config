{ config, pkgs, lib, ... }: 


{
  programs.btop = {
    enable = true;

  };

  catppuccin.btop.enable = true;
}
