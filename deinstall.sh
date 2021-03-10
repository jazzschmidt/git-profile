#!/usr/bin/env bash

set -e

hooksPath=$(git config --global core.hooksPath || true)
profilesPath=$(git config --global profile.path || true)
installPath=$(command -v git-profile  || true)

# Remove hook
[ -f "$hooksPath/pre-commit" ] && rm "$hooksPath/pre-commit"

# Remove profiles directory
[ -d "$profilesPath" ] && rm -rf "$profilesPath"

# Remove git-profile
[ -f "$installPath" ] && rm "$installPath"

# Remove global configurations
git config --global --unset profile.path 2>/dev/null || true
git config --global --unset profile.enabled 2>/dev/null || true
