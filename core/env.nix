{
  flake,
  pkgs,
  ...
}: {
  home = let
    inherit (flake) local;
    inherit (pkgs) writeShellScriptBin;
    mkFlakeScript = name: script:
      pkgs.writeShellScriptBin name script;

    #@ Define a helper to ensure we're in the flake directory
    beAtHome = ''
      case "$PWD" in "$HOME_FLAKE"/*) ;;
        *)
          pushd "$HOME_FLAKE" || exit 1
          trap 'popd' EXIT
          ;;
      esac
    '';

    #@ Define the script that handles git status and running commands
    flux = writeShellScriptBin "Flux" ''
      ${beAtHome}

      status="$(git status --short 2> /dev/null)"
      if [ -n "$status" ]; then
        gitui
      fi

      # Run additional commands if provided
      [ $# -gt 0 ] && exec "$@"
      exit 0
    '';

    fly = mkFlakeScript "Fly" ''
      Flux nix flake update
    '';

    flash = mkFlakeScript "Flash" ''
      Flux home-manager switch -b BaC --flake .
    '';

    flush = mkFlakeScript "Flush" ''
      Flux nix-store --gc && home-manager expire-generations 1
    '';

    flick = mkFlakeScript "Flick" ''
      Flush && Fly && Flash
    '';

    fmtree = mkFlakeScript "Fmtree" ''
      Flux nix fmt
    '';
  in {
    sessionVariables = {HOME_FLAKE = "${local}";};
    packages = [
      flux
      fly
      flash
      flush
      flick
      fmtree
    ];
    shellAliases = {
      Fmt = "Fmtree";
    };
  };
}
