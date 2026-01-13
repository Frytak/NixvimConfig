self:
{ pkgs, lib, config, ... }:

let
    moduleConfig = config.modules.home.frytak-nixvim;
in

{
    options.modules.home.frytak-nixvim = {
        enable = lib.mkEnableOption "Nixvim configuration of Frytak";

        package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.nixvim;
            description = "The Nixvim package to use.";
        };
    };

    config = lib.mkIf moduleConfig.enable {
        home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
