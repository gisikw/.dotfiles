# ~/.config

This is my personal configuration repository, designed to replace a traditional
`~/.dotfiles` setup by embracing the [XDG Base Directory
Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

All configuration lives inside `~/.config`, with individual tools scoped to
their own subdirectories (e.g., `nvim/`, `tmux/`, `ghostty/`). Shared environment
setup is handled by a single `env.sh` file that’s sourced by interactive
shells.

---

## 🛠 Installation

Run the installer script to clone this repository into `~/.config` and patch your shell configuration:

```bash
sh -c "$(GITHUB_USER=gisikw curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/config/main/install.sh)"
```

> You can pass a different GitHub username if you've forked this repo
>
> ```bash
> sh -c "$(GITHUB_USER=yourname curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/config/main/install.sh)"
> ```

This will:

- Clone the repo into `~/.config` (if safe to do so)
- Patch your `~/.bashrc` and/or `~/.zshrc` to source the shared environment
- Refuse to overwrite existing content unless it matches the expected repo

---

## 🧩 Shell Integration

To bring in shared environment variables and functions (like `EDITOR`, `PATH`,
and utility helpers), source `env.sh` from your shell config:

### In `~/.bashrc` or `~/.zshrc`:

```bash
[ -f "$HOME/.config/env.sh" ] && source "$HOME/.config/env.sh"
```

By default this includes a small `config` alias that lets you view the git
status of your config files at a glance.

---

## 🧱 Philosophy

- Organized under `~/.config` to align with modern tool conventions
- Easy to reason about: no alias tricks, no hidden indirection
- Portable across shells and machines with minimal setup
