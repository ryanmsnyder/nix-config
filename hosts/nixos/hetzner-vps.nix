{ user, config, inputs, pkgs, modulesPath, ... }:

let 
  keys = [ (builtins.readFile ../../keys/hetzner-vps_id_rsa.pub) ]; 
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/nixos-server/disk-config.nix
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  # # Use the systemd-boot EFI boot loader.
  # boot = {
  #   loader = {
  #     systemd-boot = {
  #       enable = true;
  #       configurationLimit = 42;
  #     };
  #     efi.canTouchEfiVariables = true;
  #   };
  #   initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  #   kernelPackages = pkgs.linuxPackages_latest;
  #   kernelModules = [ "uinput" ];
  # };

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "nixos"; # Define your hostname.
    # useDHCP = false;
    # interfaces."%INTERFACE%".useDHCP = true;
  };

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "nix-config=/home/${user}/.local/share/src/nix-config:/etc/nixos" ];
    settings.allowed-users = [ "${user}" ];
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids configurable-impure-env
    '';
   };

  # Manages keys and such
  programs = {
    gnupg.agent.enable = true;

    # Needed for anything GTK related
    dconf.enable = true;

    # My shell
    zsh.enable = true;
  };

  services.openssh = { 

    # Let's be able to SSH into this machine
    enable = true;

    settings.PasswordAuthentication = false;
    # Enable CUPS to print documents
    # printing.enable = true;
    # printing.drivers = [ pkgs.brlaser ]; # Brother printer driver


  };

  # Add docker daemon
  virtualisation = {
    docker = {
      enable = true;
      logDriver = "json-file";
    };
  };

  # It's me, it's you, it's everyone
  users.users = {
    "${user}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
       {
         command = "${pkgs.systemd}/bin/reboot";
         options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };

  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "21.05"; # Don't change this

}
