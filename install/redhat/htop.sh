#!/usr/bin/env bash
set -Eeuxo pipefail

# htop
# https://hisham.hm/htop/releases/
# https://github.com/hishamhm/htop

build_dir="/tmp/build/htop"
version="2.2.0"
prefix="/usr/local"

echo "Installing htop ${version}."

# Run preflight initialization checks.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$script_dir/_init.sh"

# SC2103: Use a ( subshell ) to avoid having to cd back.
(
    rm -rf "$build_dir"
    mkdir -p "$build_dir"
    cd "$build_dir" || return 1
    wget "https://hisham.hm/htop/releases/${version}/htop-${version}.tar.gz"
    tar -xzvf "htop-${version}.tar.gz"
    cd "htop-${version}" || return 1
    ./configure --prefix="$prefix"
    make
    make check
    sudo make install
    rm -rf "$build_dir"
)

# Ensure ldconfig is current.
sudo ldconfig

echo "htop installed successfully."
command -v htop
htop --version
