{flake, ...}: {
  home = let
    inherit (flake) local;
    # flake = "$HOME/Projects/home";
  in {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
    shellAliases = {
      Flux = "pushd ${local};git status --porcelain >/dev/null && gitui;popd:q";
      Flake = "pushd ${local};nix flake update;popd:q";
      Flash = "pushd ${local};git status --porcelain >/dev/null && gitui;home-manager switch -b BaC --flake .;popd:q";
      Flush = "pushd ${local};git status --porcelain >/dev/null && gitui;nix-store --gc;home-manager expire-generations 1;popd:q";
      Flick = "Flush;Flake;Flash:q";
    };
  };
  programs.home-manager.enable = true;
  imports = [];
}
