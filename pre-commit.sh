#!/usr/bin/env bash

enabled=$(git config profile.enabled)
enabled=${enabled:-true}

if [ "$enabled" = "false" ]; then
  exit
fi

if ! >/dev/null git profile 2>&1; then
  echo "FATAL: No profile set, aborting commit." >&2
  echo "See \`git profile help\` for further help or use \`git profile disable\` to disable profile checking." >&2
  exit 1
fi
