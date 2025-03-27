{
  description = "Lua backend for Idris 2";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: with pkgs;
        let
          idris2-lua = with idris2Packages; (buildIdris {
            src = ./.;
            idrisLibraries = [ idris2Api ];
            ipkgName = "idris2-lua";
            version = idris2Api.version;
            postInstall = ''
              wrapProgram "$out/bin/idris2-lua" \
                --suffix IDRIS2_PACKAGE_PATH ':' ${idris2}/${idris2.name}
            '';
          }).executable;
        in {
          packages = {
            inherit idris2-lua;
            default = idris2-lua;
          };
        };
    };
}
