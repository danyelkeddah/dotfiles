# dotfiles

My personal dotfiles: the setup I use on my Mac, my Linux PC and the servers I
log in to.

> [!WARNING]
> **These are mine, built for me, and they will break.**
>
> I change them whenever I feel like it, without notice and without caring
> whether anyone else's machine survives. Nothing here is a product, nothing is
> supported, and there is no stable version.
>
> If you are crazy enough to run them anyway, **read the code first** and
> understand what each package does. It is all plain shell, on purpose, so you
> can. Otherwise: your machine, your risk. I will not fix your setup.

## What it will do to your machine

Running `dot` is not a harmless config copy. Among other things it:

- **installs software** with your system package manager, using `sudo`
- **sets git's global identity to me**: my name, my email and my signing setup
  (`git/setup.sh`). You do not want this.
- **changes your login shell** to zsh
- **replaces config files** with symlinks into this repo. An existing file is
  moved aside as `<name>.bak` first.
- **rewrites macOS system settings**: Dock, Finder, keyboard, power and more
  (`system/setup.sh`)
- **reads secrets from my 1Password vaults**, which you don't have

If any of that surprises you, that is the point of the warning above.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/danyelkeddah/dotfiles/main/install.sh | sh
```

`install.sh` makes sure `git`, `curl` and `bash` exist, clones this repo to
`~/.dotfiles` and runs `dot`. Arguments are passed on:

```sh
curl -fsSL https://raw.githubusercontent.com/danyelkeddah/dotfiles/main/install.sh | sh -s -- tmux zsh
```

## Usage

```sh
dot                       # choose packages to install (type to search, Tab to toggle)
dot tmux zsh              # install specific packages
dot -y                    # install everything without asking
dot update                # pull this repo, then install everything again
dot upgrade               # upgrade the system's packages, then each package
dot upgrade nvim          # upgrade one package only
dot remove tmux           # undo a package's config (does not uninstall software)

dot --list                # list packages
dot --facts               # show what dot detected about this machine
dot --sync-secrets        # write secrets from 1Password
dot --remove-secrets      # remove them again
dot --help
```

Tab completion for zsh is included.

## How it works

Every folder with a `setup.sh` is a package. A package is a few plain
functions, and `dot` calls the one it needs:

```bash
# tmux/setup.sh
TPM="$HOME/.config/tmux/plugins/tpm"

install() {
  pkg_install tmux git
  [ -d "$TPM" ] || git clone https://github.com/tmux-plugins/tpm "$TPM"
  symlink "$DOTS/tmux/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"
}

upgrade() {
  git -C "$TPM" pull --ff-only
}

remove() {
  unlink_dot "$HOME/.config/tmux/tmux.conf"
}
```

Only `install()` is required. `upgrade()`, `remove()`, `sync_secrets()` and
`remove_secrets()` are optional. There is no hidden behaviour: what a package
does is what its functions say.

The helpers packages can use live in `_shared/`:

| Helper                                      | What it does                                                                                      |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `pkg_install tmux`                          | install with the system package manager (brew, apt, pacman, dnf); skips what is already installed |
| `pkg_install fd apt=fd-find`                | same, where one manager uses a different name                                                     |
| `pkg_install --cask ghostty`                | a Homebrew cask                                                                                   |
| `only_on macos`                             | skip the whole package on other machines                                                          |
| `symlink <from> <to>`                       | link a file into place, backing up what was there                                                 |
| `unlink_dot <path>`                         | remove such a link again, restoring the backup                                                    |
| `log_info`, `log_ok`, `log_warn`, `log_err` | output                                                                                            |

Language package managers (`pnpm`, `cargo`, `composer`) are the same on every
system, so packages call those directly.

A package that needs another one first says so with `DEPS=(rust)` at the top.

### Layout

```
dot              the runner
install.sh       bootstrap for a bare machine (POSIX sh)
_shared/         helpers: platform detection, package installs, links, output
<package>/
  setup.sh       install(), upgrade(), remove(), ...
  config/        the files that get linked into place
```

## Where it runs

`dot` detects the machine once (`dot --facts`) and packages adapt to it.

| System               | State                                                                        |
| -------------------- | ---------------------------------------------------------------------------- |
| Ubuntu / Debian      | installs tested in clean containers                                          |
| Arch                 | installs tested in clean containers                                          |
| Fedora               | detection and the basics tested; several packages are not set up for it      |
| macOS                | what I use, but with no automated tests: I find the breakage by hitting it   |
| Servers without root | supported: what needs root is skipped with a warning, config is still linked |
| Windows              | no. Use WSL.                                                                 |

On a machine with no GitHub SSH key, GitHub URLs stay on https. With a key,
everything goes over SSH.

## Secrets

No secret values are stored in this repo. Packages hold references into my
1Password vaults, and `dot --sync-secrets` reads them with the `op` CLI and
writes them to files outside the repo, such as `~/.secrets.zsh`.

## Using any of this

Don't run it. Read it, and copy the pieces you like into your own setup. If you
fork it, at the very least change `git/setup.sh` and the 1Password references
before running anything, or you will be committing as me and wondering where
your shell went.
