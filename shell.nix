{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "baconshell";

  shellHook = # bash
    ''
      if [[ ! -f .qmlls.ini ]]; then
        touch .qmlls.ini && echo ".qmlls generated!"
      fi
    '';
}
