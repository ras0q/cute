# cute installation with home-manager
{
  lib,
  config,
  pkgs,
  ...
}: {
  options.programs.cute = {
    enable =
      lib.mkEnableOption
      "Cute is a simple cute application";
    installation = lib.mkOption {
      type = lib.types.enum ["basic" "zsh-plugin"];
      default = "basic";
      description = "Choose the installation method for cute.";
    };
  };

  config = lib.mkIf config.programs.cute.enable {
    home.packages =
      lib.mkIf (
        config.programs.cute.installation == "basic"
      ) [
        pkgs.callPackage
        ./cute.nix
        {}
      ];
    programs.zsh.plugins =
      lib.mkIf (
        config.programs.cute.installation == "zsh-plugin"
      ) [
        {
          name = "cute";
          src = ../.;
          file = "cute.plugin.zsh";
        }
      ];
  };
}
