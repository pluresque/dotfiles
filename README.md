# dotfiles

> **Disclaimer:** _This is not a distribution._ It's a
> private configuration (for neovim, zellij, etc.) and an ongoing experiment to feel out Nix. Feel free
> to use it as a reference

Pretty much the whole system is configured with Nix, but Neovim itself is standalone

## nvim

I use it for almost every purpose, paired with Zellij (for sessions, panes, and floating windows), but I like to keep it minimal

I have LSP configured for:

* Python (pyright + ruff)
* Rust (rust-analyzer)
* TypeScript/JavaScript (tsserver)
* Lua (lua-language-server)
* C# (OmniSharp)

## nix

There's always room for improvement for Nix. Maybe one day I'll get around to it. For now, it manages macOS host for my main machine.

Here's what I use as of now (and want to share):
- Zen Browser - Arc w/o BS
- Sioyek - not terrible pdf/epub/... viewer
- Colima - docker that doesn't suck on macOS
- Spokenly - voice to text on local whisper model
- Amethyst - simple and straightforward window manager
- Ghostty 
