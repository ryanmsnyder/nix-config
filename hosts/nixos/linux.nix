{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  inputs,
  ...
}: {
  # FIXME: change to your tz! look it up with "timedatectl list-timezones"
  time.timeZone = "America/Los_Angeles";

  systemd.tmpfiles.rules = [
    "d /home/ryan/.config 0755 ryan users"
    "d /home/ryan/.config/lvim 0755 ryan users"
  ];

  networking.hostName = "nixos";

  # FIXME: change your shell here if you don't want zsh
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.ryan = {
    isNormalUser = true;
    # FIXME: change your shell here if you don't want zsh
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      # FIXME: uncomment the next line if you want to run docker without sudo
      # "docker"
    ];
    openssh.authorizedKeys.keys = [
      # FIXME: MAKE SURE YOU UPDATE THE ID_RSA.PUB FILE
      # Generally you should be able to do "cp ~/.ssh/id_rsa.pub ."
      (builtins.readFile ../../keys/hetzner-vps_id_rsa.pub)
    ];
  };


  system.stateVersion = "22.05";

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  nix = {
    settings = {
      trusted-users = ["ryan"];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}