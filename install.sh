#!/usr/bin/env bash

function absolute_path() {
  (
    cd "$(dirname $1)"; echo "$PWD/$(basename $1)"
  )
}

script=$(absolute_path "$0")
hooksPath=$(git config --global core.hooksPath)

if [ $? -ne 0 ]; then # Hooks path not set
  defaultHooksPath="$HOME/.git/hooks"

  echo "Hook will be installed into:"
  read -rp "Select a directory [$defaultHooksPath]: " hooksPath
  hooksPath=${hooksPath:-$defaultHooksPath}
fi

mkdir -p "$hooksPath" || >&2 echo "FATAL: Could not create directory: $hooksPath" && exit 1
[ -d "$hooksPath" ] || >&2 echo "FATAL: Is not a directory: $hooksPath" && exit 1
[ -f "$hooksPath/pre-commit" ] && >&2 echo "FATAL: There is already a pre-commit hook in $hooksPath" && exit 1

pluginPath=""
defaultPluginPath="$HOME/.git/addons"
echo "Profiles plugin will be installed into:"
read -rp "Select a directory [$defaultPluginPath]: " pluginPath
pluginPath="${pluginPath:-$defaultPluginPath}"

mkdir -p "$pluginPath" || >&2 echo "FATAL: Could not create directory: $pluginPath" && exit 1
[ -d "$pluginPath" ] || >&2 echo "FATAL: Is not a directory: $pluginPath" && exit 1
[ -f "$pluginPath/git-profile" ] && >&2 echo "FATAL: There is already a \`git-profile\` file in $pluginPath"

chmod +x pre-commit.sh && mv pre-commit.sh "$hooksPath/pre-commit"
chmod +x git-profile.sh && mv git-profile.sh "$pluginPath/git-profile"

git config --global core.hooksPath "$hooksPath"
git config --global alias.profile "!$pluginPath/git-profile"
git config --global profile.enabled true

echo "Finished installation."
echo "----------------------"
echo "Thanks for using this plugin!"
echo "Feel free to support me via GitHub: https://github.com/jazzschmidt/git-commit-user-profiles"
echo ""

remove=""
read -rn1 -p "Remove install script? [Y/n]: " remove
echo ""
if [ "$remove" = "y" ] || [ "$remove" = "Y" ]; then
  rm "$script"
fi
