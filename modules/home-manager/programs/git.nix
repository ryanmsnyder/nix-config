{ config, pkgs, lib, fullName, email, ... }:

{
    programs.git = {
        enable = true;
        ignores = [ "*.swp" ];

        lfs = {
            enable = true;
        };

        settings = {
            user = {
                name = fullName;
                email = email;
            };
            init.defaultBranch = "main";
            core = {
                editor = "vim";
                autocrlf = "input";
                pager = "bat --paging=always";
            };
            pull.rebase = true;
            rebase.autoStash = true;
            pager = {
                branch = false;
                show = false;
                log = false;
            };
        };
    };
}
