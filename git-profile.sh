#!/usr/bin/env bash

PROFILES_PATH=$(git config --global profile.path)
PROFILES_PATH=${PROFILES_PATH:-"${HOME}/.git/profiles"}

DEFAULT_USER=$(git config user.name)
DEFAULT_USER=${DEFAULT_USER:-"undefined"}

DEFAULT_EMAIL=$(git config user.email)
DEFAULT_EMAIL=${DEFAULT_EMAIL:-"undefined"}

function main() {
  local command="$1"

  if [ -n "$command" ]; then
    shift # Remove command from arguments
  fi

  case $command in
    "") active_profile;;
    list) list_profiles;;
    create) create_profile "$@";;
    edit) edit_profile "$@";;
    remove) remove_profile "$@";;
    apply) apply_profile "$@";;
    reset) reset_profile;;
    disable) disable_profiles;;
    enable) enable_profiles;;
    help) show_help;;
    *) echo "unrecognized option: ${command}" && exit 1;;
  esac
}

function show_help() {
  echo "\
Git Profile Management - applies git configurations from custom profile files.

DESCRIPTION
    In the first synopsis form, the current active profile will be printed to stdout if any. In the second synopsis form,
    different profiles can be managed. If the [profile] parameter is skipped, a interactive menu will be displayed that
    shows further details on a profile, such as the used user name and E-Mail or a custom description.

SYNOPSIS:
    git profile
    git profile subcommand [profile]

SUBCOMMANDS:
    list              Lists available profiles
    create [profile]  Creates a new profile
    edit [profile]    Edits a profile
    remove [profile]  Removes a profile
    apply [profile]   Applies a profile configuration
    reset             Resets to default configuration
    disable           Disables profile checking before committing changes
    enable            Prevents commits without any applied profile
    help              Shows this help\
"
}

function edit_profile() {
  local profile=$1; local editor; local file

  if [ -z "$profile" ]; then
    profile=$(select_profile)
  fi

  assert_profile_exists "$profile"
  file="${PROFILES_PATH}/$profile"

  editor=$(git config core.editor)
  if [ $? -ne 0 ] || [ -z "$editor" ]; then
    editor=${EDITOR:-}

    [ -z "$editor" ] && >/dev/null command -v editor && editor="editor"
    [ -z "$editor" ] && >/dev/null command -v nano && editor="nano"
    [ -z "$editor" ] && >/dev/null command -v vim && editor="vim"
    [ -z "$editor" ] && >/dev/null command -v vi && editor="vi"

    [ -z "$editor" ] && 2>&1 echo "No editor found" && exit 1
  fi

  command $editor "$file"
}

function enable_profiles() {
    git config --local profile.enabled true
}

function disable_profiles() {
    git config --local profile.enabled false
}

function active_profile() {
  assert_git_repository

  local profile;
  profile=$(git config --local profile.name)
  if [ $? ] && [ -n "$profile" ]; then
    echo "$profile"
  else
    >&2 echo "No active profile" && exit 1
  fi
}

function reset_profile() {
  assert_git_repository

  local profile; local file
  profile=$(active_profile)

  if [ $? -ne 0 ]; then
    >&2 echo "$profile" && exit 1
  fi

  file="${PROFILES_PATH}/$profile"
  IFS_old=$IFS; IFS=$'\n'
  for config in $(cat "$file"); do
    git config --local --unset "${config%=*}"
  done
  IFS=$IFS_old

  git config --local --unset profile.name
}

function apply_profile() {
  assert_git_repository

  local profile=$1; local file

  if [ -z "$profile" ]; then
    profile=$(select_profile)
  fi

  assert_profile_exists "$profile"

  file="${PROFILES_PATH}/$profile"
  IFS_old=$IFS; IFS=$'\n'
  for config in $(cat "$file"); do
    git config --local "${config%=*}" "${config#*=}"
  done
  git config --local profile.name "$profile"
  IFS=$IFS_old
}

function select_profile() {
  local profile; local available_profiles

  available_profiles=$(list_profiles)

  if [ $? -ne 0 ]; then
    >&2 echo "${available_profiles}" && exit 1
  fi

  IFS_old=$IFS; IFS=$'\n'
  PS3="Select profile: "
  select selected_profile in $available_profiles; do
    if [ -n "$selected_profile" ]; then
      profile=$(echo "$selected_profile" | sed -e 's/ -.*//')
      break
    else
      profile=$REPLY
      break
    fi
  done
  IFS=$IFS_old

  echo "$profile"
}

function create_profile() {
  local profile=$1; local name; local email; local description;
  local file;

  if [ -z "$profile" ]; then
    read -rp "Profile name: " profile
  fi

  file="${PROFILES_PATH}/${profile}"
  if [ -f "${file}" ]; then
    >&2 echo "Profile already exists: ${profile}" && exit 1
  fi

  read -rp "user name [${DEFAULT_USER}]: " user
  read -rp "user e-mail [${DEFAULT_EMAIL}]: " email
  read -rp "description [${user:-$DEFAULT_USER} <${email:-$DEFAULT_EMAIL}>]: " description

  touch "$file"

  if [ -n "$description" ]; then
    >> "$file" echo "profile.description=${description}"
  fi

  if [ -n "$user" ]; then
    >> "$file" echo "user.name=${user}"
  fi

  if [ -n "$email" ]; then
    >> "$file" echo "user.email=${email}"
  fi

  echo "Created profile ${profile} in ${PROFILES_PATH}"
}

function remove_profile() {
  local profile=$1; local file

  if [ -z "$profile" ]; then
    profile=$(select_profile)
  fi

  assert_profile_exists "$profile"

  file="${PROFILES_PATH}/${profile}"

  rm "$file" && echo "Removed profile ${profile}"
}

function list_profiles() {
  local empty=true
  for file in $PROFILES_PATH/*; do
    if [ ! -f "$file" ] ; then continue ; fi;
    empty=false

    profile=$(basename "$file")
    name=$(get_config "$file" "user.name" "${DEFAULT_USER}")
    email=$(get_config "$file" "user.email" "${DEFAULT_EMAIL}")
    description=$(get_config "$file" "profile.description" "${name} <${email}>")

    echo "$profile - ${description}"
  done

  if $empty; then
    >&2 echo "No profiles available" && exit 1
  fi
}

function get_config() {
  local file=$1; local key=$2; local defaultValue=$3
  local value
  value=$(cat "$file" | grep "$key=")
  if [ $? ] && [ -n "$value" ]; then
    echo "$value" | cut -d"=" -f2-
  else
    echo "$defaultValue"
  fi
}

function assert_profile_exists() {
  local profile=$1; local file
  file="${PROFILES_PATH}/${profile}"

  if [ ! -f "$file" ]; then
    >&2 echo "Profile does not exist: ${profile}" && exit 1
  fi
}

function assert_git_repository() {
  >/dev/null git status || exit 1
}

main "$@"
