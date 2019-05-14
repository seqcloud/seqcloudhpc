#!/usr/bin/env bash
set -Eeuxo pipefail

# Install RStudio Server.
# https://www.rstudio.com/products/rstudio/download-server/

build_dir="/tmp/build/rstudio-server"
version="1.2.1335"

echo "Installing RStudio Server ${version}."

# Run preflight initialization checks.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "${script_dir}/_init.sh"

# R is already configured by Bioconductor.
# sudo apt-get -y install r-base

# Ubuntu 18+ instructions.
sudo apt-get -y install gdebi-core
(
    rm -rf "$build_dir"
    mkdir -p "$build_dir"
    cd "$build_dir"
    wget "https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${version}-amd64.deb"
    sudo gdebi --non-interactive "rstudio-server-${version}-amd64.deb"
    rm -rf "$build_dir"
)

echo "rstudio-server installed successfully."
command -v rstudio-server
rstudio-server version
rstudio-server status
