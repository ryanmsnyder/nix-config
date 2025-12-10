{ config, pkgs, lib, ... }:

{
    programs.starship = {
        enable = true;
        # Configuration written to ~/.config/starship.toml
        settings = {
            # Sets user-defined palette
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

            gcloud = {
              disabled = true;
            };

            cmd_duration = {
                min_time = 10000; # Show command duration over 10,000 milliseconds (=10 sec)
                format = " took [$duration]($style)";
            };

            package = {
                disabled = true;
            };

            python = {
                format = "[🐍$version]($style)";
                style = "bold yellow";
            };

            nodejs = {};

            hostname = {
                ssh_only = true;
                format = "on [$hostname](bold red) ";
                style = "bold dimmed white";
                disabled = false;
            };

            nix_shell = {
                impure_msg = "";
                pure_msg = "[pure shell](bold green)";
                unknown_msg = "[unknown shell](bold yellow)";
                symbol = "❄️";
                format = " via [$symbol(\($name\))](bold blue) ";
                heuristic = true;
            };

        };
    };

    catppuccin.starship.enable = true;
}
