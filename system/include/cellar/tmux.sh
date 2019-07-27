#!/usr/bin/env bash

# Install Tmux terminal multiplexer.
# Updated 2019-06-25.

# See also:
# - https://github.com/tmux/tmux

_koopa_assert_has_no_environments

name="tmux"
version="$(koopa variable "$name")"
prefix="$(koopa cellar-prefix)/${name}/${version}"
tmp_dir="$(koopa tmp-dir)/${name}"
build_os_string="$(koopa build-os-string)"
exe_file="${prefix}/bin/${name}"

printf "Installing %s %s.\n" "$name" "$version"

(
    rm -rf "$tmp_dir"
    mkdir -p "$tmp_dir"
    cd "$tmp_dir" || exit 1
    wget "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz"
    tar -xzvf "tmux-${version}.tar.gz"
    cd "tmux-${version}" || exit 1
    ./configure \
        --build="$build_os_string" \
        --prefix="$prefix"
    make --jobs="$CPU_COUNT"
    make install
    rm -rf "$tmp_dir"
)

link-cellar "$name" "$version"

"$exe_file" -V
command -v "$exe_file"
