#!/bin/sh

# CPI shared shell configuration.
# Updated 2019-10-16 by Michael Steinbaugh.



# Notes                                                                     {{{1
# ==============================================================================

# Do not set 'LD_LIBRARY_PATH'.
# Use '/etc/ld.so.conf.d/' method instead.
# Run 'sudo ldconfig' to update shared libraries.

# Do not set 'R_HOME' or 'JAVA_HOME'.



# Koopa                                                                     {{{1
# ==============================================================================

# admin and root accounts are always skipped.
export KOOPA_SKIP_USERS="bioinfo barbara.bryant phil.drapeau"



# Azure Files                                                               {{{1
# ==============================================================================

export D1="/mnt/azbioinfoseq01"
export D2="/mnt/azbioinfoseq02"
export D3="/mnt/azbioinfoseq03"
export D4="/mnt/azbioinfoseq04"
export D5="/mnt/azbioinfoseq05"



# bcbio                                                                     {{{1
# ==============================================================================

# This value will be detected and configured automatically by koopa.
# > export BCBIO_EXE="/data00/bcbio/v1.1.5/tools/bin/bcbio_nextgen.py"
export BCBIO_EXE="/data00/bcbio/development/tools/bin/bcbio_nextgen.py"



# Cell Ranger                                                               {{{1
# ==============================================================================

# > PATH="${PATH}:/usr/local/cellranger/2.1.0"
# > PATH="${PATH}:/usr/local/cellranger/3.0.0"
# > PATH="${PATH}:/usr/local/cellranger/3.0.2"
PATH="${PATH}:/usr/local/cellranger/3.1.0"
PATH="${PATH}:/usr/local/cellranger-atac/1.1.0"



# Oracle                                                                    {{{1
# ==============================================================================

# Configuration moved to '/usr/local/lib64/R/etc/Renviron.site'.
# Refer to "ROracle" section.



# Shiny                                                                     {{{1
# ==============================================================================

alias shinystatus="sudo systemctl status shiny-server"
alias shinystart="sudo systemctl start shiny-server"
alias shinyrestart="sudo systemctl restart shiny-server"

# Consider setting this in 'Renviron.site' instead.
export SHINYAPPDATA="/mnt/azbioifnoseq05/appdata"



# Custom programs                                                           {{{1
# ==============================================================================

PATH="${PATH}:/mnt/azbioinfoseq01/projects/checksum"
export PATH
