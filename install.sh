#!/usr/bin/env bash

set -e

INSTALL_PATH=${INSTALL_PATH:-/usr/local/bin}

DEFAULT_HOOKS_PATH="$HOME/.git/hooks"
DEFAULT_PROFILES_PATH="$HOME/.git/profiles"

TAR_BALL_URL="https://api.github.com/repos/jazzschmidt/git-profile/tarball/$RELEASE"

function main() {
  if [ -z "$RELEASE" ]; then
    error "No version specified. Set \$RELEASE to a valid released version."
  fi

  # Configure hook path if not already present
  if ! hooksPath=$(git config --global core.hooksPath); then
    echo "Hook will be installed into:"
    read -rp "Select a directory [$DEFAULT_HOOKS_PATH]: " hooksPath
    hooksPath=${hooksPath:-$DEFAULT_HOOKS_PATH}
  fi


  # Configure profiles path if not already present
  if ! profilesPath=$(git config --global profiles.path); then
    echo "Profile configurations will be written into:"
    read -rp "Select a directory [$DEFAULT_PROFILES_PATH]: " profilesPath
    profilesPath=${profilesPath:-$DEFAULT_PROFILES_PATH}
  fi


  echo -n "Downloading $RELEASE... "
  dir=$(mktemp -d)
  (
    curl -fsSL "$TAR_BALL_URL" -o "$dir/git-profiles.tar.gz"
    tar -xzf "$dir/git-profiles.tar.gz" -C "$dir" --strip-components 1 &>/dev/null
  ) >/dev/null
  if [ ! $? ] ; then
    echo "" && error "Download failed"
  fi
  echo "done"

  echo -n "Installing... "
  (
    mkdir -p "$hooksPath" "$profilesPath"
    cp "$dir/git-profile.sh" "$INSTALL_PATH/git-profile" && chmod +x "$INSTALL_PATH/git-profile"
    cp "$dir/pre-commit.sh" "$hooksPath/pre-commit" && chmod +x "$hooksPath/pre-commit"

    git config --global core.hooksPath "$hooksPath"
    git config --global profile.path "$profilesPath"
    git config --global profile.enabled true
  ) >/dev/null
  if [ ! $? ] ; then
    echo "" && error "Installation failed"
  fi
  rm -rf "$dir"
  echo "done"

  echo
  echo "Finished installation."
  echo "----------------------"
  echo "Thanks for using this plugin!"
  echo "Feel free to support me via GitHub: https://github.com/jazzschmidt/git-profile"
  echo ""
}


function error() {
  >&2 echo "fatal: $1" && exit 1
}

main "$@"
