#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

# global variables
disk_low_icon=""
disk_medium_icon=""
disk_high_icon=""

disk_low_default_icon="="
disk_medium_default_icon="≡"
disk_high_default_icon="≣"

get_icon_settings() {
  disk_low_icon=$(get_tmux_option "@disk_low_icon" "$disk_low_default_icon")
  disk_medium_icon=$(get_tmux_option "@disk_medium_icon" "$disk_medium_default_icon")
  disk_high_icon=$(get_tmux_option "@disk_high_icon" "$disk_high_default_icon")
  disk_medium_thresh=$(get_tmux_option "@disk_medium_thresh" "30")
  disk_high_thresh=$(get_tmux_option "@disk_high_thresh" "80")
}

# is second float bigger or equal?
fcomp() {
  awk -v n1=$1 -v n2=$2 'BEGIN {if (n1<=n2) exit 0; exit 1}'
}

disk_status() {
  local percentage=$1
  if fcomp $disk_high_thresh $percentage; then
    echo "high"
  elif fcomp $disk_medium_thresh $percentage && fcomp $percentage $disk_high_thresh; then
    echo "medium"
  else
    echo "low"
  fi
}

print_icon() {
  local disk_percentage=$($CURRENT_DIR/disk-percentage.sh | sed -e 's/%//')
  local disk_usage_status=$(disk_status $disk_percentage)
  if [ "$disk_usage_status" == "low" ]; then
    echo "$disk_low_icon"
  elif [ "$disk_usage_status" == "medium" ]; then
    echo "$disk_medium_icon"
  elif [ "$disk_load_status" == "high" ]; then
    echo "$disk_high_icon"
  fi
}

main() {
  get_icon_settings
  print_icon "$1"
}
main
