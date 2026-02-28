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

    # MCP servers (top-level option - gets passed as --mcp-config flag to claude binary)
    mcpServers = {
      chrome-devtools = {
        type = "stdio";
        command = "${pkgs.nodejs_24}/bin/npx";
        args = [ "-y" "chrome-devtools-mcp@latest" ];
      };
      CodeGraphContext = {
        type = "stdio";
        command = "${config.home.homeDirectory}/.local/bin/cgc";
        args = [ "mcp" "start" ];
      };
      pal = {
        type = "stdio";
        command = "${config.home.homeDirectory}/local-mcp-servers/pal-mcp-server/.pal_venv/bin/python";
        args = [ "${config.home.homeDirectory}/local-mcp-servers/pal-mcp-server/server.py" ];
        cwd = "${config.home.homeDirectory}/local-mcp-servers/pal-mcp-server";
        env = {
          DEFAULT_MODEL = "auto";
          DEFAULT_THINKING_MODE_THINKDEEP = "high";
          CONVERSATION_TIMEOUT_HOURS = "24";
          MAX_CONVERSATION_TURNS = "40";
          LOG_LEVEL = "DEBUG";
          DISABLED_TOOLS = "analyze,refactor,testgen,secaudit,docgen,tracer";
          PAL_MCP_FORCE_ENV_OVERRIDE = "false";
          COMPOSE_PROJECT_NAME = "pal-mcp";
          TZ = "UTC";
          LOG_MAX_SIZE = "10MB";
        };
      };
    };
  };

  # Statusline script needs to be placed manually (executable)
  home.file.".claude/statusline.sh" = {
    source = ../config/claude/statusline.sh;
    executable = true;
  };

  # Install codegraphcontext CLI via uv tool (not in nixpkgs)
  home.activation.installCodeGraphContext = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.uv}/bin/uv tool list 2>/dev/null | grep -q "codegraphcontext"; then
      ${pkgs.uv}/bin/uv tool install codegraphcontext --python 3.12
    fi
  '';

  # Write context7 MCP server config into ~/.claude.json using agenix-decrypted API key.
  # context7 uses HTTP transport with a secret API key in headers, so it can't go in the
  # nix store via mcpServers. Instead we template it in at activation time.
  home.activation.setupContext7Mcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    KEY_FILE="${config.home.homeDirectory}/.config/claude/context7-api-key"
    CLAUDE_JSON="${config.home.homeDirectory}/.claude.json"
    if [ -f "$KEY_FILE" ]; then
      API_KEY=$(cat "$KEY_FILE")
      CONTEXT7_CONFIG=$(${pkgs.jq}/bin/jq -n \
        --arg key "$API_KEY" \
        '{mcpServers: {context7: {type: "http", url: "https://mcp.context7.com/mcp", headers: {CONTEXT7_API_KEY: $key}}}}')
      if [ -f "$CLAUDE_JSON" ]; then
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$CLAUDE_JSON" <(echo "$CONTEXT7_CONFIG") > "$CLAUDE_JSON.tmp" \
          && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
      else
        echo "$CONTEXT7_CONFIG" > "$CLAUDE_JSON"
      fi
    fi
  '';
}
