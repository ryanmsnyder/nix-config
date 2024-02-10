{ config, pkgs, lib, name, email, ... }:

let name = "Ryan Snyder";
    email = "ryansnyder4@gmail.com";
in

{
    programs.git = {
        enable = true;
        ignores = [ "*.swp" ];
        userName = name;
        userEmail = email;

        lfs = {
            enable = true;
        };

        extraConfig = {
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
