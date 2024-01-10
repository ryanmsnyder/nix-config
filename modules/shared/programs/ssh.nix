{ config, pkgs, lib, user, ... }:

let user = "ryansnyder";

in

{
  programs.ssh = {
    enable = true;

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          IdentitiesOnly yes
      ''

      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        ''
          IdentityFile /home/${user}/.ssh/github_id_ed25519
        '')

      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        ''
          IdentityFile /Users/${user}/.ssh/github_id_ed25519
        '')

      ''
        Host nixos-playground
          Hostname 46.226.105.17
          User root
      ''

            (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        ''
          IdentityFile /home/${user}/.ssh/gandi-vps_id_rsa
        '')

      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        ''
          IdentityFile /Users/${user}/.ssh/gandi-vps_id_rsa
        '')

    ];
  };
}

