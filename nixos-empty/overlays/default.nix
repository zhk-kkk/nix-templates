{inputs, ...}: {
  # Make unstable packages be accecible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = final.allowUnfree;
    };
  };
}
