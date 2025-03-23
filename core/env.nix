{
  config,
  pkgs,
  paths,
  ...
}: let
  inherit (paths) local;
  inherit (pkgs) writeShellScriptBin;

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

  fly = writeShellScriptBin "Fly" ''
    Flux nix flake update
  '';

  flash = writeShellScriptBin "Flash" ''
    Flux home-manager switch -b BaC --flake .
  '';

  flush = writeShellScriptBin "Flush" ''
    Flux home-manager expire-generations 1 && nix-collect-garbage --delete-old
  '';

  flick = writeShellScriptBin "Flick" ''
    Flux Flush && Fly && Flash
  '';

  fmtree = writeShellScriptBin "Fmtree" ''
    Flux nix fmt
  '';
in {
  home = {
    # file."hmConf".source = config.lib.file.mkOutOfStoreSymlink paths.local; #TODO: What can this do?
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
