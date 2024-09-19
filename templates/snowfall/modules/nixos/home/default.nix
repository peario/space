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
    configFile =
      mkOpt attrs { }
        "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>.";
  };

  config = {
    ${namespace}.home.extraOptions = {
      home = {
        inherit (config.system) stateVersion;
        file = mkAliasDefinitions options.${namespace}.home.file;
      };
      xdg = {
        enable = true;
        configFile = mkAliasDefinitions options.${namespace}.home.configFile;
      };
    };

    home-manager = {
      # enables backing up existing files instead of erroring if conflicts exist
      backupFileExtension = "hm.old";

      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.${namespace}.user.name} = mkAliasDefinitions options.${namespace}.home.extraOptions;

      verbose = true;
    };
  };
}
