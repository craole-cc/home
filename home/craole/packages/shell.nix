{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        format-nix = "nix run nixpkgs#alejandra --";
        fmtree = "treefmt";
      };
      initExtra = ''
        fmtree() {
          treefmt "$@"
        }
      '';
    };
    atuin = {
      enable = true;
      enableBashIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
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
