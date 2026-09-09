# dotfiles

Personal shell configuration, installed via a single script.

## What's here

- [`install.sh`](install.sh) — downloads the files below from this repo (raw GitHub) into place, installing [Starship](https://starship.rs) if it isn't already present.
- [`starship.toml`](starship.toml) — Starship prompt config: Slurm cluster name (on HPC only) + hostname + directory + git branch on one line, status character on the next.
- [`bashrc.d/terminal-setup.sh`](bashrc.d/terminal-setup.sh) — bash setup: ensures `~/.local/bin` is on `PATH`, enables bash completion, exports `CLUSTER_NAME` on Slurm clusters, and initializes Starship.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MRo47/dotfiles/main/install.sh | bash
```

This installs:

- `~/.local/bin/starship` (if missing)
- `~/.config/starship.toml`
- `~/.config/bash/terminal-setup.sh`

It also appends a line to `~/.bashrc` sourcing the setup script, if one isn't there already. Re-running the installer won't add it twice.

Then reload your shell (`source ~/.bashrc` or open a new terminal).

### With Nerd Font icons

The Starship prompt config uses [Nerd Font](https://www.nerdfonts.com) glyphs (e.g. the git branch symbol), which regular fonts don't include. Pass `--fonts` to also download and install the JetBrains Mono Nerd Font to `~/.local/share/fonts`:

```bash
curl -fsSL https://raw.githubusercontent.com/MRo47/dotfiles/main/install.sh | bash -s -- --fonts
```

After installing, set your terminal's font to "JetBrainsMono Nerd Font" for the icons to render correctly.

## HPC clusters

On a Slurm cluster the hostname is a node name (`ln03`) that doesn't say which machine you're on, and `hostname -f` isn't reliably configured. The setup script therefore reads the cluster name from `scontrol show config` and exports it as `CLUSTER_NAME`, which the prompt shows before the hostname:

```
marenostrum5 ln03::scratch  main
❯
```

`scontrol` queries the Slurm controller, which is too slow to run on every prompt, so the result is cached in `~/.cache/dotfiles/cluster-<hostname>` and read from there afterwards. The lookup is skipped entirely where `scontrol` isn't installed, so the prompt is unchanged on a laptop. To force a refresh, delete the cache file.
