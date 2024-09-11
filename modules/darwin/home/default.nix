{
  config,
  lib,
  options,
  namespace,
  ...
}:
let
  inherit (lib) types mkAliasDefinitions;
  inherit (lib.${namespace}) mkOpt;
in
{

  options.${namespace}.home = with types; {
    file = mkOpt attrs { } "Files to be managed by home-manager's <option>home.file</option>.";
    configFile =
      mkOpt attrs { }
        "Files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    homeConfig = mkOpt attrs { } "Final config for home-manager.";
  };

  config = {
    ${namespace}.home.extraOptions = {
      home.file = mkAliasDefinitions options.${namespace}.home.file;

      xdg = {
        enable = true;

        configFile = mkAliasDefinitions options.${namespace}.home.configFile;
      };
    };

    snowfallorg.users.${config.${namespace}.user.name}.home.config =
      mkAliasDefinitions
        options.${namespace}.home.extraOptions;

    home-manager = {
      # enables backing up existing files instead of erroring if conflicts exist
      backupFileExtension = "hm.old";

      useUserPackages = true;
      useGlobalPkgs = true;

      verbose = true;
    };
  };
}
