# Kevin Gisi's Dotfiles

These are my personal dotfiles, and are designed to be bootstrappable and
self-documenting. They are instrumented entirely in bash, except for where
configuration for a particular tool assumes the use of that tool (e.g. vim).

I don't recommend cloning this repository, but if you want to use it as a
baseline for your own dotfiles, you'll want to update `bootstrap.sh` to refer
to your own GitHub repository.

## Installation

```bash
curl https://bit.ly/kgdot | bash
```

## Usage

The repository is cloned to `~/.dotfiles`, and symlinks point things like
`~/.vimrc` to `~/.dotfiles/vimrc`. The `bashrc` file in the root of the
repository handles pushing and pulling changes, setting up aliases, and
ensuring symlinks exist.

There are two utilities provided to easily synchronize and modify the dotfiles,
as described below:

```bash
$ up # Commits any changes, syncs with GitHub, and sources ~/.bash_profile or ~/.bashrc
$ dot # Opens ~/.dotfiles/bashrc in vim, and runs up on quit
```

`up` is automatically run when you open a new shell, to ensure the dotfiles are
always kept in sync. Note, however, that if you don't have internet
connectivity, `bashrc` will detect this, and skip over remote sync.

## Configuration

Where possible, configuration options are specified in `config.yml`. These are
parsed using the `bash/craml.sh` file, which uses GNU tools to parse a subset
of the YAML spec (I've named the utility "craml", as in "CRappy yAML"). Aliases
and symlinks are specified within this file.

## Notes on Vim

The `vimrc` in this repository will automatically download and install
[Vundle](https://github.com/VundleVim/Vundle.vim) if it is missing. Additional
plugins are specified using Vundle, but the `~/.vim` directory is not
maintained as part of this dotfiles repository. Rather, you can install plugins
by running `:PluginInstall` inside vim itself.
