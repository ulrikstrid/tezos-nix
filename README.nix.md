# Tezos nix setup

`nix-shell` setup to work with the tezos codebase

## Usage

Clone this repo next to the tezos repo

Run the following command to copy the files and patch exludes etc:

```sh
./scripts/add-to-tezos.sh [./path-to-tezos]
```

Then you can use it like this

```sh
git --git-dir=.git-nix [...command]
```

or add an alias for `nix-git` that can be used like standard `git` like this

```sh
alias nix-git='git --git-dir=.git-nix'
```
