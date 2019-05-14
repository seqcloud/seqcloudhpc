#!/usr/bin/env bash
set -Eeuxo pipefail

# R
# https://www.r-project.org/
#
# See also:
# - https://cran.r-project.org/doc/manuals/r-release/R-admin.html
# - https://community.rstudio.com/t/compiling-r-from-source-in-opt-r/14666
# - https://superuser.com/questions/841270/installing-r-on-rhel-7
# - https://github.com/rstudio/rmarkdown/issues/359
# - http://pj.freefaculty.org/blog/?p=315

build_dir="/tmp/build/r"
prefix="/usr/local"

major_version="3"
minor_version="6.0"
version="${major_version}.${minor_version}"

echo "Installing R ${version}."

# Run preflight initialization checks.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "${script_dir}/_init.sh"

# Install build dependencies.
sudo yum-builddep -y R

# Install TeX dependencies.
# Missing recommendations:
# - texlive-csvsimple
# - texlive-fonts-extra
# - texlive-inconsolata
# - texlive-marginfix
# - texlive-mathtools
# - texlive-nowidow
# - texlive-parnotes

sudo yum install -y \
    texlive \
    texlive-bera \
    texlive-collection-fontsrecommended \
    texlive-collection-latexrecommended \
    texlive-caption \
    texlive-changepage \
    texlive-enumitem \
    texlive-etoolbox \
    texlive-fancyhdr \
    texlive-footmisc \
    texlive-framed \
    texlive-geometry \
    texlive-hyperref \
    texlive-latex-fonts \
    texlive-natbib \
    texlive-parskip \
    texlive-pdftex \
    texlive-placeins \
    texlive-preprint \
    texlive-sectsty \
    texlive-soul \
    texlive-titlesec \
    texlive-titling \
    texlive-xstring

# Using TeX Live 2013, we'll see this warning:
#
# configure: WARNING: neither inconsolata.sty nor zi4.sty found: PDF vignettes and
# package manuals will not be rendered optimally
#
# There doesn't appear to be an easy way to fix this on RHEL.

# Now we're ready to compile R.

# SC2103: Use a ( subshell ) to avoid having to cd back.
(
    rm -rf "$build_dir"
    mkdir -p "$build_dir"
    cd "$build_dir"
    wget "https://cran.r-project.org/src/base/R-${major_version}/R-${version}.tar.gz"
    tar -xzvf "R-${version}.tar.gz"
    cd "R-${version}"
    ./configure \
        --build="x86_64-redhat-linux-gnu" \
        --prefix="$prefix" \
        --enable-BLAS-shlib \
        --enable-R-profiling \
        --enable-R-shlib \
        --enable-memory-profiling \
        --with-blas \
        --with-cairo \
        --with-jpeglib \
        --with-lapack \
        --with-readline \
        --with-tcltk
    make
    make check
    sudo make install
    rm -rf "$build_dir"
)

# Need to update LD config.
sudo ldconfig

echo "R installed successfully."
command -v R
R --version

# Current output in PuTTY:
# > capabilities()
#        jpeg         png        tiff       tcltk         X11        aqua
#        TRUE        TRUE        TRUE        TRUE       FALSE       FALSE
#    http/ftp     sockets      libxml        fifo      cledit       iconv
#        TRUE        TRUE        TRUE        TRUE        TRUE        TRUE
#         NLS     profmem       cairo         ICU long.double     libcurl
#        TRUE        TRUE        TRUE        TRUE        TRUE        TRUE

cat << EOF
RStudio server configuration must be updated to use this version of R.

(1) Stop the server:
sudo rstudio-server stop

(2) Edit /etc/rstudio/rserver.conf to contain this line:
rsession-which-r=/usr/local/bin/R

(3) Restart the server:
sudo rstudio-server restart

EOF
