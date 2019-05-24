#!/usr/bin/env bash
set -Eeuxo pipefail

# Tmux terminal multiplexer
# https://github.com/tmux/tmux

build_dir="/tmp/build/tmux"
prefix="/usr/local"
version="2.9a"

echo "Installing tmux ${version}."

# Run preflight initialization checks.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=/dev/null
. "${script_dir}/_init.sh"

# apt-cache search libevent
sudo apt-get -y install libevent-dev

# SC2103: Use a ( subshell ) to avoid having to cd back.
(
    rm -rf "$build_dir"
    mkdir -p "$build_dir"
    cd "$build_dir" || return 1
    wget "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz"
    tar -xzvf "tmux-${version}.tar.gz"
    cd "tmux-${version}" || return 1
    ./configure --prefix="$prefix"
    make
    sudo make install
    rm -rf "$build_dir"
)

# Ensure ldconfig is current.
sudo ldconfig

echo "tmux installed successfully."
command -v tmux
tmux -V
