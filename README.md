# dotfiles

Personal shell configuration, installed via a single script.

## What's here

- [`install.sh`](install.sh) — downloads the files below from this repo (raw GitHub) into place, installing [Starship](https://starship.rs) if it isn't already present.
- [`starship.toml`](starship.toml) — Starship prompt config: directory + git branch on one line, status character on the next.
- [`bashrc.d/terminal-setup.sh`](bashrc.d/terminal-setup.sh) — bash setup: ensures `~/.local/bin` is on `PATH`, enables bash completion, and initializes Starship.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MRo47/dotfiles/main/install.sh | bash
```

This installs:

- `~/.local/bin/starship` (if missing)
- `~/.config/starship.toml`
- `~/.config/bash/terminal-setup.sh`

### With Nerd Font icons

The Starship prompt config uses [Nerd Font](https://www.nerdfonts.com) glyphs (e.g. the git branch symbol), which regular fonts don't include. Pass `--fonts` to also download and install the JetBrains Mono Nerd Font to `~/.local/share/fonts`:

```bash
curl -fsSL https://raw.githubusercontent.com/MRo47/dotfiles/main/install.sh | bash -s -- --fonts
```

After installing, set your terminal's font to "JetBrainsMono Nerd Font" for the icons to render correctly.

## Enable

Add this to your `~/.bashrc` to source the installed setup script:

```bash
[ -f "$HOME/.config/bash/terminal-setup.sh" ] && . "$HOME/.config/bash/terminal-setup.sh"
```

Then reload your shell (`source ~/.bashrc` or open a new terminal).
