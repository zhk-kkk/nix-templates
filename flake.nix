{
  description = "zhk's collection of flake templates";

  outputs = { self }: {
    templates = {
      default = self.templates.development;
      development = {
        path = ./development;
        description = "zhk's basic development shell";
      };
    };
  };
}
