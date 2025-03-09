{ config, pkgs, lib, ... }: 


{
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };

  };

  catppuccin.bat.enable = true;
}
