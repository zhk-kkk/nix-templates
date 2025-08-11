{
  cfglib,
  inputs,
  ...
}: let
  outputs = inputs.self.outputs;
  lib = inputs.nixpkgs.lib;
in {
  # mkModules usage:
  # "x86_64-linux"
  # [
  #   {
  #       path = "./modules/nixos/features";
  #       namespace = "";
  #       inputs = {};
  #   }
  #   {
  #       path = "./modules/nixos/bundles";
  #       namespace = "bundles";
  #       inputs = {};
  #   }
  #   {
  #       path = "./modules/nixos/services";
  #       namespace = "services";
  #       inputs = {};
  #   }
  # ]

  # Generate modules from a tree of custom modules
  mkModules = namespaceDescriptions:
    builtins.concatLists (map (
        namespaceDesc:
          map (
            customModulePath:
              cfglib.expandCustomModule namespaceDesc.namespace customModulePath (
                if namespaceDesc ? extraInputs then namespaceDesc.extraInputs else {}
              )
          ) (cfglib.pathsIn namespaceDesc.path)
      )
      namespaceDescriptions);

  # Expand a module
  expandCustomModule = namespaceName: customModulePath: extraInputs: let
    moduleName = cfglib.baseNameStemOf customModulePath;
  in
    {
      config,
      inputs,
      outputs,
      cfglib,
      pkgs,
      lib,
      ...
    } @ moduleInputs: let
      customModule = import customModulePath {
        cfglib = cfglib.scopes.configuration;
        inherit config inputs outputs pkgs lib;
      } // extraInputs;

      opts =
        {
          enable = lib.mkEnableOption (
            if namespaceName == ""
            then "enable ${moduleName} custom feature"
            else "enable ${moduleName} custom ${namespaceName}"
          );
        }
        // (
          if customModule ? options
          then customModule.options
          else {}
        );

      cfg = builtins.removeAttrs customModule ["options"];
    in {
      options.custom = (
        if namespaceName == ""
        then {${moduleName} = opts;}
        else {${namespaceName}.${moduleName} = opts;}
      );

      config =
        lib.mkIf (
          if namespaceName == ""
          then config.custom.${moduleName}.enable
          else config.custom.${namespaceName}.${moduleName}.enable
        )
        cfg;
    };
}
