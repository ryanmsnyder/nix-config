{ config, pkgs, lib, name, email, ... }:


{
    programs.neovim = {
        enable = true;
        defaultEditor = true;

        # Alias vim and vi to nvim
        viAlias = true;
        vimAlias = true; 

        extraPackages = with pkgs; [
            lua-language-server
        ];
    };

    # Symlink entire nvim directory. mkOutOfStoreSymlink is supposed to create a symlink outside of the nix 
    # store (in this case, directly to the modules/config/neovim directory). However, it appears to not work correctly on MacOS
    # because ~/.config/nvim is still symlinked to the nix store. However, it still solved my issue, which was that my
    # lazy-lock.json file wasn't writeable. Using mkOutOfStoreSymlink gave the file write permissions.
    home.file."./.config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/modules/shared/config/neovim";

}
