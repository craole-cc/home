{
  flake,
  pkgs,
  ...
}: {
  home = let
    inherit (flake) local;
    flakeScripts = {
      flux = pkgs.writeShellScriptBin "Flux" ''
        case "$PWD" in  "$HOME_FLAKE"/*) ;;
          *)
            pushd "$HOME_FLAKE" || exit 1
            trap 'popd' EXIT
           ;;
        esac

        status="$(git status --short  2> /dev/null)"
        if [ -n "$status" ]; then
          gitui
        else
          exit 0
        fi
      '';

      flake = pkgs.writeShellScriptBin "Flake" ''
        if [[ "$PWD" != "$HOME_FLAKE" ]]; then
          pushd "$HOME_FLAKE" || exit 1
          trap 'popd' EXIT
        fi
        nix flake update
      '';

      flash = pkgs.writeShellScriptBin "Flash" ''
        if [[ "$PWD" != "$HOME_FLAKE" ]]; then
          pushd "$HOME_FLAKE" || exit 1
          trap 'popd' EXIT
        fi
        git status --porcelain >/dev/null && gitui
        home-manager switch -b BaC --flake .
      '';

      flush = pkgs.writeShellScriptBin "Flush" ''
        if [[ "$PWD" != "$HOME_FLAKE" ]]; then
          pushd "$HOME_FLAKE" || exit 1
          trap 'popd' EXIT
        fi
        status="$(git status --short  2> /dev/null)"
        git status --porcelain >/dev/null && gitui
        nix-store --gc
        home-manager expire-generations 1
      '';

      flick = pkgs.writeShellScriptBin "Flick" ''
        Flush && Flake && Flash
      '';

      fmtree = pkgs.writeShellScriptBin "Fmtree" ''
        nix fmt
      '';
    };
  in {
    sessionVariables = {HOME_FLAKE = "${local}";};
    packages = with flakeScripts; [
      flux
      flake
      flash
      flush
      fmtree
      flick
    ];
    shellAliases = {
      Fmt = "fmtree";
    };
  };
}
