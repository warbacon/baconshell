{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "baconshell";

  packages = [
    pkgs.qt6Packages.qtdeclarative
    pkgs.brightnessctl
    pkgs.libnotify
  ];

  shellHook = # bash
    ''
      if [[ ! -f .qmlls.ini ]]; then
        touch .qmlls.ini && echo ".qmlls generated!"
      fi
    '';
}
