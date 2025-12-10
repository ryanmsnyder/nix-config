{ config, pkgs, lib, ... }:

{
  imports = [
    ./colima.nix
    ./open-webui.nix
    ./ollama.nix
  ];
}
