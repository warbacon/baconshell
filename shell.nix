{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = [
    pkgs.kdePackages.qtdeclarative
    pkgs.libnotify
  ];

  shellHook = # bash
    ''
      if [[ ! -f .qmlls.ini ]]; then
        touch .qmlls.ini && echo ".qmlls generated!"
      fi
    '';
}
