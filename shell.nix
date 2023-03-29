{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "dev";
  nativeBuildInputs = with pkgs; [
    nixFlakes
    go-task
    envsubst
  ];
}
