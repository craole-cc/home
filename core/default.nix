{
  home =
    let
      flake = "$HOME/Projects/home";
    in
    {
      stateVersion = "24.11";
      username = "craole";
      homeDirectory = "/home/craole";
      shellAliases = {
        Flux = ''
          pushd "${flake}"
          git status --porcelain >/dev/null && gitui
          popd
        '';
        Flake = ''
          pushd "${flake}"
          nix flake update
          popd
        '';
        Flash = ''
          pushd "${flake}"
          git status --porcelain >/dev/null && gitui
          home-manager switch -b BaC --flake .
          popd
        '';
        Flush = ''
          pushd "${flake}"
          git status --porcelain >/dev/null && gitui
          nix-store --gc
          home-manager expire-generations 1
          popd
        '';
        Flick = ''
          Flush
          Flake
          Flash
        '';
      };
    };
  programs.home-manager.enable = true;
  imports = [ ];
}
