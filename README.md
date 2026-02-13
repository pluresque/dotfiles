# Dotfiles

Personal multi-platform config for my desktop, laptop and homelab.

## Nvim

Managed via `vim.pack` (built-in package manager, no lazy.nvim). Gruvbox Material hard theme.

Plugins: treesitter, nvim-lspconfig, blink.cmp (completion), fzf-lua (fuzzy finder + ui-select), flash (jump motions), aerial (code outline), conform (formatting), nvim-lint, neogit, undotree, rustaceanvim, kulala (REST client), peek (markdown preview), codediff, wakatime. Heavy use of mini.nvim: files, ai, surround, bufremove, bracketed, git, diff, notify, hipatterns, icons.

LSP servers: pyright, ruff, ts_ls, omnisharp, yamlls (with k8s/docker-compose/github schemas), phpactor, lua_ls. Document highlighting, inlay hints toggle, codelens.

Key bindings: `<leader><space>` files, `<leader>/` grep, `<leader>,` buffers, `<Enter>` flash jump, `<C-e>` mini.files, `<leader>cf` format, `gd/gr/gi/ga` LSP navigation.

## Nix

Multi-platform config: macOS (nix-darwin) and NixOS (desktop + homelab server). Single unstable nixpkgs channel everywhere

### Hosts

| Host | Platform | Arch | What it is |
|------|----------|------|------------|
| `pluresque` | macOS (nix-darwin) | aarch64-darwin | MBA M1 |
| `pluresque-desktop` | NixOS | x86_64-linux | AMD 7700XT, Hyprland, Btrfs |
| `pluresque-homelab` | NixOS | aarch64-linux | headless server, Docker + Podman, hardened SSH |

### Structure

```
.config/nix/
├── flake.nix
├── apps/                        # helper scripts per platform
│   ├── aarch64-darwin/          # build-switch, apply, clean, rollback
│   ├── x86_64-linux/            # build-switch, apply, clean, create-keys, copy-keys
│   └── aarch64-linux -> x86_64-linux
├── hosts/
│   ├── darwin/                  # macOS host config
│   └── nixos/
│       ├── pluresque-desktop/   # desktop with Hyprland + SDDM + PipeWire
│       └── pluresque-homelab/   # server with Docker/Podman
├── modules/
│   ├── shared/                  # cross-platform: nix settings, shell, git, packages, fonts
│   ├── darwin/                  # macOS-only: system defaults, homebrew, secrets
│   └── nixos/                   # NixOS-only: desktop environment, disk layout, secrets
└── overlays/                    # auto-loaded, drop .nix files here
```

Three-tier module system - `shared` is imported by every host, then `darwin` or `nixos` layers on top. Packages live in `shared/packages.nix` as a plain function (not a module), called by platform-specific home-manager configs which add their own extras (e.g. `colima` on macOS, `xdg-utils` on NixOS)

### Usage

macOS — build and switch:
```sh
# from .config/nix/
nix run .#build-switch

# or manually
nix build .#darwinConfigurations.pluresque.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#pluresque
```

NixOS — build and switch:
```sh
nix run .#build-switch -- --host pluresque-desktop
# or
sudo nixos-rebuild switch --flake .#pluresque-desktop
```

Fresh NixOS install (formats disk via disko):
```sh
nix run .#apply -- --host pluresque-desktop
```

### agenix

Secrets are managed with [agenix](https://github.com/ryantm/agenix). The placeholder configs are in `modules/darwin/secrets.nix` and `modules/nixos/secrets.nix`

Setup:

1. Generate an age keypair (or use an existing SSH ed25519 key)
2. Create a `secrets/` repo with a `secrets.nix` that lists your public keys
3. Encrypt secrets: `agenix -e my-secret.age`
4. Reference them in the secrets module:
```nix
age.secrets."my-secret" = {
  file = "${secrets}/my-secret.age";
  path = "/home/pluresque/.config/whatever";
  mode = "600";
  owner = "pluresque";
};
```
On NixOS you can generate fresh keys with `nix run .#create-keys` or copy them from USB with `nix run .#copy-keys`

