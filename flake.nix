{
  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let pkgs = (import nixpkgs { inherit system; }); in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Generally useful
          gdb
          # For scripts
          shellcheck
          # Day 1
          gcc
          binutils
          # Day 2
          gawk
          # Day 4
          pltScheme
          # Day 5
          ocaml
          # Day 6
          python39
          mypy
          # Day 7
          gnat
          # Day 8
          php80
        ];
      };
    }
  );
}
