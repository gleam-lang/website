#!/bin/sh

# This script uses the gleam compiler CLI to generate markdown
# from its own help output.

set -e

trim() {
  sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//'
}

find_description() {
  sed -n '2,/^USAGE:/p' | grep -v 'USAGE:' | trim
}

find_subcommands() {
  sed -n '/SUBCOMMANDS:/,/^$/p' | grep -v 'SUBCOMMANDS:' | grep -v '^$' | trim | cut -d' ' -f1
}

find_usage() {
  sed -n '/USAGE:/,/^$/p' | grep -v 'USAGE:' | grep -v '^$' | trim
}

find_options() {
  # We ignore the --help option as it is not useful in these docs,
  # grep returns 1 if no matches, we need to ignore that for the pipeline to work.
  set +e
  # Some subcommands empty lines in the middle of the options lists, so we cannot use `sed -n '/OPTIONS:/,/^$/p'`.
  # There are some options that span multiple lines, we need to join them.
  sed -n '/OPTIONS:/,//p' | grep -v 'OPTIONS:' | tr '\n' '§' | sed -E 's/§ *-/\n-/g' | sed 's/§ */ /g' | trim | grep -v -- '--help'
  set -e
}

# Render markdown help for a subcommand, or a subcommand under it.
show_docs() {
  subcommand="$1"
  subsubcommand="$2"

  if [ -z "$subsubcommand" ]; then
    help=$(gleam help "$subcommand")
    heading="## \`$subcommand\`"
  else
    help=$(gleam help "$subcommand" "$subsubcommand")
    heading="### \`$subcommand $subsubcommand\`"

    subsubsubcommand=$(echo "$help" | find_subcommands)
    if [ -n "$subsubsubcommand" ]; then
      echo >&2 "Subcommand \`$subcommand $subsubcommand\` has subcommands, this is not supported"
      exit 1
    fi

  fi

  description=$(echo "$help" | find_description)
  usage=$(echo "$help" | find_usage)
  options=$(echo "$help" | find_options)

  echo
  echo "$heading"
  echo
  echo \`"$usage"\`
  echo
  echo "$description"
  echo
  if [ -n "$options" ]; then
    echo "| Option | Description |"
    echo "| ------ | ----------- |"
    echo "$options" | sed 's/^/| \`/' | sed -E 's/(  +|$)/\`| /'
  fi
}

cat <<EOF
---
title: Command line reference
subtitle: Getting Gleam things done in the terminal
layout: page
---

<!-- This file is automatically generated by \`writing-gleam/command-line-reference.sh\` -->

The \`gleam\` command uses subcommands to access different parts of the functionality:
EOF

# Note: lsp is a "hidden" command so it will not be shown by `gleam help`
subcommands=$(gleam help | find_subcommands)

for subcommand in $subcommands; do

  show_docs "$subcommand"

  for subsubcommand in $(gleam help "$subcommand" | find_subcommands); do

    if [ "$subsubcommand" = "help" ]; then
      continue
    fi

    show_docs "$subcommand" "$subsubcommand"

  done

done