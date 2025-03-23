{flake, ...}: {
  home = let
    inherit (flake) local;
  in {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
    # sessionVariables = {
    #   HOME_FLAKE = "${local}";
    # };
    # shellAliases = {
    #   Flux = "pushd $HOME_FLAKE;git status --porcelain >/dev/null && gitui;popd";
    #   Flake = "pushd $HOME_FLAKE;nix flake update;popd";
    #   Flash = "pushd $HOME_FLAKE;git status --porcelain >/dev/null && gitui;home-manager switch -b BaC --flake .;popd";
    #   Flush = "pushd $HOME_FLAKE;git status --porcelain >/dev/null && gitui;nix-store --gc;home-manager expire-generations 1;popd";
    #   Flick = "Flush;Flake;Flash";
    #   Fmt = "nix fmt";
    # };
  };
  programs.home-manager.enable = true;
  imports = [./env.nix];
}
