{
  description = "Nix flake for Cute - a CLI tool that exeCUTEs commands from Markdown files.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      flake.homeModules = {
        default = import ./nix/home-module.nix;
      };
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
        packages.default = pkgs.callPackage ./nix/cute.nix {};
      };
    };
}
