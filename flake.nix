{
  description = "zhk's collection of flake templates";

  outputs = { self }: {
    templates = {
      default = self.templates.development;
      development = {
        path = ./development;
        description = "zhk's basic development shell";
      };
      nixos-empty = {
        path = ./nixos-empty;
        description = "zhk's bare-bones multi-host NixOS flake configuration with custom modules system";
      };
    };
  };
}
