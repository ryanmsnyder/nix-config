{ config, pkgs, lib, home-manager, fullName, user, email, inputs, ... }:

{
  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs fullName user email;
    };

    users.${user} = {
      imports = [
        ../home-manager
      ];
    };
  };
}
