{pkgs, ...}: {
  imports = [
    ./git.nix
    ./nix.nix
    ./shell.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) ["discord"];
}
