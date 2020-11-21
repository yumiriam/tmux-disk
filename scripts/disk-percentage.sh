#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

disk_percentage_format="%3.1f%%"

get_percentage() {
  local disk="$(get_disk)"
  df | grep "$disk$" | awk -v format="$disk_percentage_format" '{
    usage=$3/$2*100
  } END {
    printf(format, usage)
  }'
}

get_disk_usage() {
  local os="$1"

  disk_percentage_format=$(get_tmux_option "@disk_percentage_format" "$disk_percentage_format")
  if [[ "$os" == "linux" || "$os" == "osx" ]]; then
      echo -n $(get_percentage)
      return 0
  else
      echo -n "0"
      return 1
  fi
}

main() {
  local os=$(get_os_type)

  echo -n "$(get_disk_usage $os)"
}
main
