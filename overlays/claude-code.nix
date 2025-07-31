final: prev: {
  claude-code = prev.claude-code.overrideAttrs (old: rec {
    version = "1.0.64";
    
    src = final.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-do/RbjQu+E4hfw1/iNrAt+Jm1OROwooSxJCLDNd4LZw=";
    };

    # Using the same npmDepsHash as the original 0.2.109 version since dependencies appear compatible
    npmDepsHash = "sha256-u5AZXNlN/NAag+35uz3rzLh6ItbKAdV8RSSjzCGk6uA=";
  });
}
