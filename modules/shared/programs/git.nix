{ config, pkgs, lib, name, email, ... }:

{
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;  # You can replace this with a variable if needed
    userEmail = email;  # Same as above, replace with a variable if needed

    lfs = {
        enable = true;
    };

    extraConfig = {
        init.defaultBranch = "main";
        core = { 
        editor = "vim";
        autocrlf = "input";
        };
        pull.rebase = true;
        rebase.autoStash = true;
    };
}
