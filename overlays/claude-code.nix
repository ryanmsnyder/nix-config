final: prev: {
  claude-code = prev.claude-code.overrideAttrs (old: rec {
    version = "2.0.5";
    
    src = final.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-ZAolpT/NW48NpIoY2jUzbBlcHmyNcw+G1GhZ40qtJoY=";
    };

    # Using the same npmDepsHash as the original 0.2.109 version since dependencies appear compatible
    npmDepsHash = "sha256-u5AZXNlN/NAag+35uz3rzLh6ItbKAdV8RSSjzCGk6uA=";
  });
}
