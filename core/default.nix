{flake, ...}: {
  home = let
    inherit (flake) local;
  in {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
    shellAliases = {
      Flux = "pushd ${local};git status --porcelain >/dev/null && gitui;popd";
      Flake = "pushd ${local};nix flake update;popd";
      Flash = "pushd ${local};git status --porcelain >/dev/null && gitui;home-manager switch -b BaC --flake .;popd";
      Flush = "pushd ${local};git status --porcelain >/dev/null && gitui;nix-store --gc;home-manager expire-generations 1;popd";
      Flick = "Flush;Flake;Flash";
      Fmt = "nix fmt";
    };
    sessionVariables = {
      HOME_FLAKE = "${local}";
    };
  };
  programs.home-manager.enable = true;
  imports = [];
}
