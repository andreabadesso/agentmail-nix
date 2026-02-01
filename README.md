# agentmail-nix

Nix packaging for the [agentmail](https://github.com/agentmail-to/agentmail-python) Python SDK.

Versions are automatically updated every 6 hours via GitHub Actions.

## Installation

### Flake (recommended)

Add to your `flake.nix` inputs:

```nix
inputs.agentmail.url = "github:agentmail-to/agentmail-nix";
```

Then use the package or overlay:

```nix
# Direct package
agentmail.packages.${system}.default

# Or apply the overlay to get python3Packages.agentmail
nixpkgs.overlays = [ agentmail.overlays.default ];
```

### Legacy (nix-env)

```sh
nix-env -f https://github.com/agentmail-to/agentmail-nix/archive/main.tar.gz -iA defaultNix.packages.x86_64-linux.default
```

### Dev shell

```sh
nix develop github:agentmail-to/agentmail-nix
```
