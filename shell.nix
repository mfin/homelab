{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "dev";
  nativeBuildInputs = with pkgs; [
    nixVersions.stable
    go-task
    envsubst
  ];
}
