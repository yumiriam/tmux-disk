#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

main() {
  local disk_block_size="$(get_disk_block_size)"
  local disk="$(get_disk)"

  echo -n "$(get_disk_used $disk_block_size $disk)"
}
main
