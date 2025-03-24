{
  description = "Home Manager configuration";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = import inputs.systems;
      imports = with inputs; [
        # flake-parts.flakeModules.partitions
        easy-hosts.flakeModule
        home-manager.flakeModules.home-manager
        ./core
        ./home
        # devshell.flakeModule
        # treefmt-nix.flakeModule
      ];
      flake = {
        lib = (import ./lib inputs.nixpkgs) // inputs.home-manager.lib;
        dots.paths.base = "$HOME/Projects/admin";
      };
    };
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    haumea = {
      type = "github";
      owner = "nix-community";
      repo = "haumea";
    };

    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
    };

    deploy-rs = {
      type = "github";
      owner = "serokell";
      repo = "deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    devshell = {
      type = "github";
      owner = "numtide";
      repo = "devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      type = "github";
      owner = "cachix";
      repo = "git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-github-actions = {
      type = "github";
      owner = "nix-community";
      repo = "nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-unit = {
      type = "github";
      owner = "nix-community";
      repo = "nix-unit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-hardware = {
    #   type = "github";
    #   owner = "NixOS";
    #   repo = "nixos-hardware";
    # };

    # nixos-wsl = {
    #   type = "github";
    #   owner = "nix-community";
    #   repo = "NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # disko = {
    #   type = "github";
    #   owner = "nix-community";
    #   repo = "disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # impermanence = {
    #   type = "github";
    #   owner = "nix-community";
    #   repo = "impermanence";
    # };

    # hyprland = {
    #   type = "github";
    #   owner = "cachix";
    #   repo = "git-hooks.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
}
