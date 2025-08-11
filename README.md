# nix-templates
My nix flake templates

Examples:
```
# Use the default template to create a new flake in the current directory
nix flake init -t github:zhk-kkk/nix-templates

# Use the `development` template to create a new flake in the current directory
nix flake init -t github:zhk-kkk/nix-templates#development

# Use the default template to create a new flake in `./example`
nix flake new -t github:zhk-kkk/nix-templates ./example

# Use the `development` template to create a new flake in `./example`
nix flake new -t github:zhk-kkk/nix-templates#development ./example
```
