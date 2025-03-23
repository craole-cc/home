{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      format-nix = "nix run nixpkgs#alejandra --";
    };
    initExtra = ''
      # Add your custom bash configurations here
    '';
  };
}
