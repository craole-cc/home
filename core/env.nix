{
  flake,
  pkgs,
  ...
}: {
  home = let
    inherit (flake) local;
    mkFlakeScript = name: script:
      pkgs.writeShellScriptBin name script;

    beAtHome = ''
      case "$PWD" in  "$HOME_FLAKE"/*) ;;
        *)
          pushd "$HOME_FLAKE" || exit 1
          trap 'popd' EXIT
          ;;
      esac
    '';

    flux = mkFlakeScript "Flux" ''
      ${beAtHome}
      status="$(git status --short  2> /dev/null)"
      if [ -n "$status" ]; then
        gitui
        [ $# -gt 0 ] && "$@"
      else
        [ $# -gt 0 ] && "$@"
        exit 0
      fi
    '';

    fly = mkFlakeScript "Flake" ''
      ${beAtHome}
      nix flake update
    '';

    flash = mkFlakeScript "Flash" ''
      Flux
      ${beAtHome}
      home-manager switch -b BaC --flake .
    '';

    flush = mkFlakeScript "Flush" ''
      Flux
      ${beAtHome}
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
