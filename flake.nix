{
  description = "Lua backend for Idris 2";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    idris2_0_5_0 = {
      url = "github:idris-lang/Idris2?ref=v0.5.0";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: with pkgs;
        let
          idris2' = inputs.idris2_0_5_0.packages.${system}.idris2;
          buildIdris' = idris2Packages.buildIdris.override {
            idris2 = idris2';
          };
          idris2-api' = callPackage (
            { lib, idris2Packages }: (buildIdris' {
              inherit (idris2') src version;
              ipkgName = "idris2api";
              idrisLibraries = [ ];
              preBuild = ''
                export IDRIS2_PREFIX=$out/lib
                make src/IdrisPaths.idr
              '';
            }).library {}
          ) {};
          idris2-lua = buildIdris' {
            src = ./.;
            idrisLibraries = [ idris2-api' ];
            ipkgName = "idris2-lua";
          };
        in {
          packages.default = idris2-lua.executable;
        };
    };
}
