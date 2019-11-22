#!/usr/bin/env bash
set -Eeu -o pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
# shellcheck source=/dev/null
source "${script_dir}/../../../shell/bash/include/header.sh"

# _koopa_remove_broken_symlinks "$(_koopa_config_prefix)"

if _koopa_is_darwin
then
    update-homebrew
    update-r-packages
    # > if _koopa_has_sudo
    # > then
    # >     update-tex
    # > fi
fi

if _koopa_is_azure
then
    update-azure-vm --all
else
    update-conda
fi

update-venv
update-rust

# Loop across config directories and update git repos.
# Consider nesting these under 'app' directory.
config_dir="$(_koopa_config_prefix)"
dirs=(
    Rcheck
    docker
    dotfiles
    dotfiles-private
    oh-my-zsh
    rbenv
    scripts-private
    spacemacs
)
for dir in "${dirs[@]}"
do
    # Skip directories that aren't a git repo.
    if [[ ! -x "${config_dir}/${dir}/.git" ]]
    then
        continue
    fi
    _koopa_message "Updating '${dir}'."
    (
        cd "${config_dir}/${dir}" || exit 1
        # Run updater script, if defined.
        # Otherwise pull the git repo.
        if [[ -x "UPDATE.sh" ]]
        then
            ./UPDATE.sh
        else
            git fetch --all
            git pull
        fi
    )
done

# Update repo.
_koopa_message "Updating koopa."
(
    cd "$KOOPA_PREFIX" || exit 1
    git fetch --all
    # > git checkout master
    git pull
)

# Clean up legacy files.
if [[ -d "${KOOPA_PREFIX}/system/config" ]]
then
    rm -frv "${KOOPA_PREFIX}/system/config"
fi

if _koopa_is_linux
then
    reset-prefix-permissions
    prefix="$(_koopa_make_prefix)"
    remove-broken-symlinks "$prefix"
    remove-empty-dirs "$prefix"
    remove-broken-cellar-symlinks
fi

# > remove-broken-symlinks "$HOME"

_koopa_message "koopa update was successful."
_koopa_note "Shell must be reloaded for changes to take effect."
