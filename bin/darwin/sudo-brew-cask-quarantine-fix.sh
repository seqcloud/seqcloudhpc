#!/usr/bin/env bash
set -Eeuo pipefail

# Disable quarantine on installed applications.
# This is useful for installed Homebrew casks.

sudo xattr -r -d com.apple.quarantine /Applications/*.app
