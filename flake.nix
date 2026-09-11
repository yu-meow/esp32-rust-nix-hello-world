{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";

    nixpkgs-mozilla = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      flake-utils,
      naersk,
      nixpkgs,
      nixpkgs-mozilla,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;

          overlays = [
            (import nixpkgs-mozilla)
          ];
        };

        toolchain =
          with fenix.packages.${system};
          fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "sha256-mvUGEOHYJpn3ikC5hckneuGixaC+yGrkMM/liDIDgoU=";
          };

        naersk' = pkgs.callPackage naersk {
          cargo = toolchain;
          rustc = toolchain;
        };

      in
      {
        # For `nix build`:
        defaultPackage = naersk'.buildPackage {
          src = ./.;
          release = true;
        };

        # For `nix build .#flash`
        packages.flash = naersk'.buildPackage {
          src = ./.;
          release = true;
          buildInputs = [ pkgs.espflash ];
          postInstall = "espflash flash --chip esp32c6 $out/bin/result";
        };

        # For `nix build .#build-flash`
        packages.build-flash = naersk'.buildPackage {
          src = ./.;
          release = true;
          buildInputs = [ pkgs.espflash ];
          postInstall = "espflash flash --monitor --chip esp32c6 $out/bin/result";
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.espflash ];
          nativeBuildInputs = [ toolchain ];
        };
      }
    );
}
