#!/usr/bin/env bash
set -Eeuxo pipefail

# ShellCheck
#
# See also:
# - Install ShellCheck from source
#   https://github.com/koalaman/shellcheck#compiling-from-source
# - Install GHC and cabal-install from source
#   https://www.haskell.org/downloads/linux/

build_dir="/tmp/build/shellcheck"
version="0.6.0"

# Run preflight initialization checks.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=/dev/null
. "${script_dir}/_init.sh"

# Note that EPEL version is super old and many current checks don't work.
echo "Installing old EPEL version of ShellCheck to /usr/bin."
sudo yum install -y epel-release ShellCheck

echo "Copying newer ${version} binary version to /usr/local/bin."
(
    rm -rf "$build_dir"
    mkdir -p "$build_dir"
    cd "$build_dir"
    wget -qO- "https://storage.googleapis.com/shellcheck/shellcheck-v${version}.linux.x86_64.tar.xz" | tar -xJv
    sudo cp "shellcheck-v${version}/shellcheck" /usr/local/bin/
    rm -rf "$build_dir"
)

echo "shellcheck installed successfully."
command -v shellcheck
shellcheck --version
