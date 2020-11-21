#!/usr/bin/env bash

PATH="/usr/local/bin:$PATH:/usr/sbin"

get_tmux_option() {
  local option_name="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv $option_name)"

  if [ -z "$option_value" ]; then
    echo -n "$default_value"
  else
    echo -n "$option_value"
  fi
}

set_tmux_option() {
  local option_name="$1"
  local option_value="$2"
  $(tmux set-option -gq $option_name "$option_value")
}

get_disk() {
  echo -n "$(get_tmux_option "@disk_mount_point" "/")"
}

get_disk_block_size() {
  echo -n "$(get_tmux_option "@disk_block_size" "g")"
}

get_os_type() {
  local os_name="unknown"

  case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
      os_name="linux"
      ;;
    darwin*)
      os_name="osx"
      ;;
    msys*)
      os_name="windows"
      ;;
    freebsd*)
      os_name="freebsd"
      ;;
  esac

  echo -n $os_name
}

get_df_value() {
  local disk_block_size="$1"
  local disk="$2"
  local field="$3"

  local os=$(get_os_type)

  case "$os" in
    linux)
      echo -n $(df --block-size="$disk_block_size" | grep "$disk$" | awk -v field="$field" '{ print $field }')
      return 0;
      ;;
    osx)
      echo -n $(df -"$disk_block_size" | grep "$disk$" | awk -v field="$field" '{ print $field }')
      return 0;
      ;;
    *)
      echo ""
      return 1;
      ;;
    esac
}

get_disk_size() {
  echo -n "$(get_df_value $1 $2 2)"
}

get_disk_used() {
  echo -n "$(get_df_value $1 $2 3)"
}

get_disk_avail() {
  echo -n "$(get_df_value $1 $2 4)"
}
