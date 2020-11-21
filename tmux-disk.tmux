#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/scripts/helpers.sh"

disk_placeholders=(
  "\#{disk_percentage}"
  "\#{disk_size}"
  "\#{disk_used}"
  "\#{disk_available}"
  "\#{disk_icon}"
)

disk_commands=(
  "#($CURRENT_DIR/scripts/disk-percentage.sh)"
  "#($CURRENT_DIR/scripts/disk-size.sh)"
  "#($CURRENT_DIR/scripts/disk-used.sh)"
  "#($CURRENT_DIR/scripts/disk-available.sh)"
  "#($CURRENT_DIR/scripts/disk-icon.sh)"
)

replace_placeholder() {
  local value="$1"
  for ((i=0; i<${#disk_commands[@]}; i++)); do
    value=${value//${disk_placeholders[$i]}/${disk_commands[$i]}}
  done
  echo "$value"
}

update_tmux_option() {
  local option=$1
  local old_option_value=$(get_tmux_option "$option")
  local new_option_value=$(replace_placeholder "$old_option_value")

  echo "old: $old_option_value"
  echo "new: $new_option_value"
  $(set_tmux_option $option "$new_option_value")
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main
