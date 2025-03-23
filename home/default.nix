{
  home = {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
  };
  programs.home-manager.enable = true;
  imports = [./environment ./packages];
}
