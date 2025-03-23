{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -la";
        format-nix = "nix run nixpkgs#alejandra --";
      };
      initExtra = ''
        # Add your custom bash configurations here
      '';
    };
    atuin = {
      enable = true;
      enableBashIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
    };
    thefuck = {
      enable = true;
      enableBashIntegration = true;
    };
    yazi = {
      enable = true;
      enableBashIntegration = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
