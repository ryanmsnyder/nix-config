{ config, pkgs, lib, inputs, ... }:

{
  programs.claude-code = {
    enable = true;

    # Use llm-agents.nix package for daily auto-updates
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

    # Settings (maps to ~/.claude/settings.json)
    settings = {
      apiKeyHelper = "~/.claude/anthropic_key.sh";
      model = "opusplan";
      alwaysThinkingEnabled = false;
      statusLine = {
        type = "command";
        command = "~/.claude/statusline.sh";
        padding = 0;
      };
      enabledPlugins = {
        "claude-notifications-go@claude-notifications-go" = true;
      };
    };

    # Global memory/instructions (maps to ~/.claude/CLAUDE.md)
    memory.text = ''
      ## Tooling for shell interactions
      Is it about finding FILES? use 'fd'
      Is it about finding TEXT/strings? use 'ripgrep'
      Is it about finding CODE STRUCTURE? use 'ast-grep'
      Is it about interacting with JSON? use 'jq'
      Is it about interacting with YAML or XML? use 'yq'
    '';

    # Custom commands (maps to ~/.claude/commands/)
    # Note: .md extension is added automatically by the module
    commands = {
      "commit" = ''
        Add the relevant files to git staging and create a conventional git commit. Don't mention Claude in the commit message.
      '';
    };

    # Skills directory (symlink entire directory for runtime files)
    skillsDir = ../config/claude/skills;
  };

  # Statusline script needs to be placed manually (executable)
  home.file.".claude/statusline.sh" = {
    source = ../config/claude/statusline.sh;
    executable = true;
  };
}
