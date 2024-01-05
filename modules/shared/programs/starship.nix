{ config, pkgs, lib, ... }:

{
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
        # Sets user-defined palette
        palette = "catppuccin_macchiato";

        add_newline = true;

        character = {
        success_symbol = "[➜](green)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
        };

        directory = {
            truncation_length = 5;
            style = "bold sapphire";
        };

        git_commit = {
        commit_hash_length = 8;
        style = "bold white";
        };

        git_state = {
        format = "[\\($state( $progress_current of $progress_total)\\)]($style) ";
        };

        git_status = {
        conflicted = "⚔️ ";
        ahead = "🏎️💨×$count ";
        behind = "🐢×$count ";
        diverged = "🔱 🏎️💨×$ahead_count 🐢×$behind_count ";
        untracked = "🛤️×$count ";
        stashed = "📦 ";
        modified = "📝×$count ";
        staged = "🗃️×$count ";
        renamed = "📛×$count ";
        deleted = "🗑️×$count ";
        style = "bright-white";
        format = "$all_status$ahead_behind";
        };

        cmd_duration = {
        min_time = 10000; # Show command duration over 10,000 milliseconds (=10 sec)
        format = " took [$duration]($style)";
        };

        package = {
        disabled = true;
        };

        python = {
        format = "[$symbol$version]($style)";
        style = "bold yellow";
        };

        nodejs = {};

        hostname = {
        ssh_only = true;
        format = "on [$hostname](bold red) ";
        style = "bold dimmed white";
        disabled = false;
        };

        palettes = {
            catppuccin_macchiato = {
                rosewater = "#f4dbd6";
                flamingo = "#f0c6c6";
                pink = "#f5bde6";
                mauve = "#c6a0f6";
                red = "#ed8796";
                maroon = "#ee99a0";
                peach = "#f5a97f";
                yellow = "#eed49f";
                green = "#a6da95";
                teal = "#8bd5ca";
                sky = "#91d7e3";
                sapphire = "#7dc4e4";
                blue = "#8aadf4";
                lavender = "#b7bdf8";
                text = "#cad3f5";
                subtext1 = "#b8c0e0";
                subtext0 = "#a5adcb";
                overlay2 = "#939ab7";
                overlay1 = "#8087a2";
                overlay0 = "#6e738d";
                surface2 = "#5b6078";
                surface1 = "#494d64";
                surface0 = "#363a4f";
                base = "#24273a";
                mantle = "#1e2030";
                crust = "#181926";
            };
        };
    };
}