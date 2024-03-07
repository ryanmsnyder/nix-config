{ config, pkgs, lib, name, email, ... }:


{
    programs.neovim = {
        enable = true;
        defaultEditor = true;

        # Alias vim and vi to nvim
        viAlias = true;
        vimAlias = true; 

        # Install LSPs, formatters, linters, DAPs
        extraPackages = with pkgs; [
            # Language servers
            # ccls
            emmet-ls
            # gopls
            # jdt-language-server
            # ltex-ls
            lua-language-server
            # nil
            nodePackages.bash-language-server
            # nodePackages.graphql-language-service-cli
            nodePackages.svelte-language-server
            nodePackages.typescript-language-server
            # prisma-ls
            pyright
            ruff-lsp
            nodePackages.vscode-langservers-extracted
            # typst-lsp

            # efm-langserver sources
            alejandra
            # asmfmt
            black
            # cppcheck
            deadnix
            # editorconfig-checker
            efm-langserver
            gitlint
            # gofumpt
            # nodePackages.alex
            nodePackages.prettier
            python3Packages.flake8
            # shellcheck
            # shellharden
            # shfmt
            statix
            stylua

            # DAP servers
            # Create a custom Python environment with debugpy for DAP
            (python311.withPackages (ps: with ps; [
                debugpy
            ]))
        ];
    };

    # Symlink entire nvim directory. mkOutOfStoreSymlink is supposed to create a symlink outside of the nix 
    # store (in this case, directly to the modules/config/neovim directory). However, it appears to not work correctly on MacOS
    # because ~/.config/nvim is still symlinked to the nix store. However, it still solved my issue, which was that my
    # lazy-lock.json file wasn't writeable. Using mkOutOfStoreSymlink gave the file write permissions.
    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/shared/home-manager/config/neovim";

}
