{
  home = {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
    shellAliases = {
      rebuild = ''
        git status --porcelain >/dev/null && gitui
        home-manager switch -b BaC --flake ~/Projects/home
      '';
    };
  };
  programs.home-manager.enable = true;
  imports = [];
}
