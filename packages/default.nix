{pkgs, ...}: {
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  # nixpkgs.config.allowUnfreePredicate = pkgs: builtins.elem (pkgs.lib.getName pkg) ["discord"];
}
