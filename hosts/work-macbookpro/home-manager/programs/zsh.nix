{ ... }:

{
  programs.zsh.initContent = ''
    # Langfuse credentials
    [[ -f "$HOME/.config/langfuse/.env" ]] && source "$HOME/.config/langfuse/.env"
  '';
}
