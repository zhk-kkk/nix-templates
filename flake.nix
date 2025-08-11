{
  description = "zhk's collection of flake templates";

  outputs = { self }: {
    defaultTemplate = self.templates.development;
    templates = {
      development = {
        path = ./development;
        description = "zhk's basic development shell";
      };
    };
  }
}
