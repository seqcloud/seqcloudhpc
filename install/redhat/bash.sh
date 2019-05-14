#!/usr/bin/env bash
set -Eeuxo pipefail

# Bash
# https://www.gnu.org/software/bash/

build_dir="/tmp/build/bash"
prefix="/usr/local"
version="5.0"

echo "Installing bash ${version}."

# Run preflight initialization checks.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$script_dir/_init.sh"

# Install build dependencies
sudo yum-builddep -y bash

# SC2103: Use a ( subshell ) to avoid having to cd back.
(
    rm -rf "$build_dir"
    mkdir -p "$build_dir"
    cd "$build_dir"
    wget http://ftpmirror.gnu.org/bash/bash-${version}.tar.gz
    tar -xzvf "bash-${version}.tar.gz"
    cd "bash-${version}"
    ./configure --build="x86_64-redhat-linux-gnu" --prefix="$prefix"
    make
    make test
    sudo make install
    rm -rf "$build_dir"
)

# Consider adding a check in /etc/shells.
# grep "${prefix}/bin/bash" /etc/shells
# And then if there's no match, append the file automatically.

echo "Updating default shell."
chsh -s /usr/local/bin/bash

echo "Reloading the shell."
exec bash

echo "bash installed successfully."
command -v bash
bash --version
