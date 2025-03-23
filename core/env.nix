{
  flake,
  pkgs,
  ...
}: {
  home = let
    inherit (flake) local;
    mkFlakeScript = name: script:
      pkgs.writeShellScriptBin name script;

    flux = mkFlakeScript "Flux" ''
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

    fly = mkFlakeScript "Flake" ''
      if [[ "$PWD" != "$HOME_FLAKE" ]]; then
        pushd "$HOME_FLAKE" || exit 1
        trap 'popd' EXIT
      fi
      nix flake update
    '';

    flash = mkFlakeScript "Flash" ''
      if [[ "$PWD" != "$HOME_FLAKE" ]]; then
        pushd "$HOME_FLAKE" || exit 1
        trap 'popd' EXIT
      fi
      git status --porcelain >/dev/null && gitui
      home-manager switch -b BaC --flake .
    '';

    flush = mkFlakeScript "Flush" ''
      if [[ "$PWD" != "$HOME_FLAKE" ]]; then
        pushd "$HOME_FLAKE" || exit 1
        trap 'popd' EXIT
      fi
      status="$(git status --short  2> /dev/null)"
      git status --porcelain >/dev/null && gitui
      nix-store --gc
      home-manager expire-generations 1
    '';

    flick = mkFlakeScript "Flick" ''
      Flush && Flake && Flash
    '';

    fmtree = mkFlakeScript "Fmtree" ''
      nix fmt
    '';
  in {
    sessionVariables = {HOME_FLAKE = "${local}";};
    packages = [
      flux
      flash
      flush
      flick
      fly
      fmtree
    ];
    shellAliases = {
      Fmt = "fmtree";
    };
  };
}
