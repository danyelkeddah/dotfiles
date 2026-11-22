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
dot tmux zsh              # install specific packages: get the software, then configure it
dot -y                    # install everything without asking
dot configure nvim        # only link config and apply settings
dot upgrade               # upgrade the system's packages, then each package
dot upgrade mise          # upgrade one package only
dot unconfigure tmux      # undo a package's config, keep the software
dot uninstall tmux        # undo the config, then remove the software
dot update                # pull this repo, then install everything again

dot --list                # list packages
dot --facts               # show what dot detected about this machine
dot --sync-secrets        # write secret files from 1Password
dot --remove-secrets      # remove them again
dot run <package> <function>   # run any one function of a package
dot --help
```

Tab completion for zsh is included.

## How it works

Every folder with a `setup.sh` is a package. A package is a few plain
functions, and `dot` calls the ones it needs:

```bash
# tmux/setup.sh
DEPS=(mise)                       # tmux itself comes from mise

TPM="$HOME/.config/tmux/plugins/tpm"

install() {
  [ -d "$TPM" ] || git clone https://github.com/tmux-plugins/tpm "$TPM"
}

configure() {
  symlink "$DOTS/tmux/config/tmux.conf" "$HOME/.config/tmux/tmux.conf"
}

upgrade() {
  git -C "$TPM" pull --ff-only
}

unconfigure() {
  unlink_dot "$HOME/.config/tmux/tmux.conf"
}

uninstall() {
  rm -rf "$HOME/.config/tmux/plugins"
}
```

| Function | Meaning | Run by |
| --- | --- | --- |
| `install` | get the software | `dot install` |
| `configure` | link config, apply settings | `dot install`, `dot configure` |
| `upgrade` | move to a newer version | `dot upgrade` |
| `unconfigure` | undo `configure` | `dot unconfigure`, `dot uninstall` |
| `uninstall` | remove the software | `dot uninstall` |
| `sync_secrets`, `remove_secrets` | write and remove secret files | `dot --sync-secrets`, `dot --remove-secrets` |

All of them are optional: a package defines the ones that mean something for
it. Packages whose software is shared with the rest of the system, like `git`
and `zsh`, have no `uninstall` on purpose. There is no hidden behaviour: what a
package does is what its functions say.

The helpers packages can use live in `_shared/`:

| Helper                                      | What it does                                                                                      |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `pkg_install tmux`                          | install with the system package manager (brew, apt, pacman, dnf); skips what is already installed |
| `pkg_install fd apt=fd-find`                | same, where one manager uses a different name                                                     |
| `pkg_install --cask ghostty`                | a Homebrew cask                                                                                   |
| `pkg_uninstall tmux` | remove it again; on apt and pacman the package manager asks first |
| `only_on macos`                             | skip the whole package on other machines                                                          |
| `symlink <from> <to>`                       | link a file into place, backing up what was there                                                 |
| `unlink_dot <path>`                         | remove such a link again, restoring the backup                                                    |
| `log_info`, `log_ok`, `log_warn`, `log_err` | output                                                                                            |

Language package managers (`pnpm`, `cargo`, `composer`) are the same on every
system, so packages call those directly.

A package that needs another one first says so with `DEPS=(mise)` at the top.

### Tools come from mise

Languages and most command-line tools are not installed one package at a time.
They are listed in one file, [`mise/config/config.toml`](mise/config/config.toml),
and [mise](https://mise.jdx.dev) installs them: go, node, php, pnpm, rust,
neovim, tmux, fzf, ripgrep, gh, lazygit, kubectl, k9s and the rest. It works
the same on macOS and Linux and always takes the newest release. Almost all of
it needs no root. php is the exception: mise builds it from source, so on
Linux without root it is left out.

```sh
dot configure mise  # install whatever the file lists and isn't there yet
dot upgrade mise    # move everything to its newest release
```

Packages such as `nvim` or `k9s` then only link their config.

A machine that was set up before mise took over still has the old copies (nvm,
brew and apt packages, downloaded binaries). `dot run mise cleanup_old` lists
them and asks before removing them.

### Layout

```
dot              the runner
install.sh       bootstrap for a bare machine (POSIX sh)
_shared/         helpers: platform detection, package installs, links, output
<package>/
  setup.sh       install(), configure(), upgrade(), ...
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
| Servers without root | supported: mise installs the tools into your home folder, what needs root is skipped with a warning, config is still linked |
| Windows              | no. Use WSL.                                                                 |

On a machine with no GitHub SSH key, GitHub URLs stay on https. With a key,
everything goes over SSH.

## Secrets

No secret values are stored in this repo, only references into my 1Password
vaults.

- **Keys for commands** are not kept in the shell's environment. A command that
  needs one is started through `with-secrets`, which asks 1Password for the
  values in `zsh/config/zsh/secrets.refs` and gives them to that one process.
- **Secret files** (the git signers file, a licence key) are written outside
  the repo by `dot --sync-secrets`.
- **`~/.secrets.zsh`** is for what 1Password cannot hand out itself, such as
  the service account token that lets `op` work on a server. It is created by
  hand on that machine and never committed.

## Using any of this

Don't run it. Read it, and copy the pieces you like into your own setup. If you
fork it, at the very least change `git/setup.sh` and the 1Password references
before running anything, or you will be committing as me and wondering where
your shell went.
