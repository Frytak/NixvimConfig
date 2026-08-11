{
    description = "Nixvim configuration of Frytak";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        flake-parts.url = "github:hercules-ci/flake-parts";

        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim = {
            url = "github:nix-community/nixvim/nixos-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, flake-parts, nixvim, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

        imports = [
            inputs.home-manager.flakeModules.home-manager
        ];

        perSystem = { config, self', inputs', pkgs, system, ... }: let
            nixvim' = nixvim.legacyPackages.${system};
        in {
            packages.default = nixvim'.makeNixvimWithModule {
                inherit pkgs;
                module = import ./config;
                extraSpecialArgs = { inherit inputs; };
            };

            devShells.default = pkgs.mkShell {
                packages = [ self'.packages.default ];
            };
        };

        flake = {
            homeModules.default = import ./nixvimHomeModule.nix self;
        };
    };
}
