{
  description = "Nix flake for R development";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        # Base packages
        basePackages = with pkgs; [
          pandoc
          quarto
          R
          radianWrapper
        ];
        # R packages
        rPackages = with pkgs.rPackages; [
          # Utils
          devtools
          knitr
          languageserver
          rmarkdown
          # Project
          tidyverse
        ];
        allPackages = basePackages ++ rPackages;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = allPackages;
          shellHook = ''
            export R_LIBS_USER=$PWD/R/Library;
            mkdir -p "$R_LIBS_USER";
            echo "R environment set up";
          '';
        };
      });
}
