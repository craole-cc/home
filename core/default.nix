{
  home = {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
    shellAliases = {
      # rebuild = ''home-manager switch --flake ${self}'';
    };
  };
  programs.home-manager.enable = true;
  imports = [ ];
}
