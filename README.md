Tmux file system disk space status
==================================

Enables displaying file system disk space in Tmux `status-right` and
`status-left`. The information is based on `df` command.
Allows the configuration of filesystem mount point, percentage format,
block-size unit and icon.

Installation
------------

### Instalation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

```shell
set -g @plugin 'yumiriam/tmux-disk'
```

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

### Manual Installation

Clone the repo:

```shell
$ git clone https://github.com/yumiriam/tmux-disk ~/clone/path
```

Add this line to the bottom of `.tmux.conf`:

```shell
run-shell ~/clone/path/tmux-disk.tmux
```

Reload TMUX environment:

```shell
# type this in terminal
$ tmux source-file ~/.tmux.conf
```

If format strings are added to `status-right`, they should now be visible.

## Usage

Add any of the supported format strings (see below) to the existing
`status-left` or `status-right` tmux option. Example:

```shell
# in .tmux.conf
set -g status-right 'Disk: #{disk_available} #{disk_icon} | %a %h-%d %H:%M '
```

### Supported Options

This plugin relies on `df` command to show information that can be added to
the `status-left` or to the `status-right` options by adding the following
format strings:

- `#{disk_size}` - shows the size of the selected file system
- `#{disk_used}` - shows the used space for the selected file system
- `#{disk_available}` - shows the available space for the selected file system
- `#{disk_percentage}` - shows the percentage of use (used / size)
- `#{disk_icon}` - will display the disk usage status icon (based on the
  percentage of use)

## Customization

These are the available customization variables and their default values:

```shell
@disk_mount_point "/" # mount point of the target filesystem
@disk_block_size "g" # unit to scale sizes, see 'SIZE' or 'BLOCKSIZE' of
                     # 'man df' for reference

@disk_low_icon "=" # icon when usage is low
@disk_medium_icon "≡" # icon when usage is medium
@disk_high_icon "≣" # icon when usage is high

@disk_percentage_format "%3.1f%%" # printf format to display percentage

@disk_medium_thresh "30" # medium percentage threshold
@disk_high_thresh "80" # high percentage threshold
```

You can can customize each one of these options in your `.tmux.conf`, for
example:

```shell
set -g @disk_medium_thresh "42"
set -g @disk_percentage_format "%5.1f%%" # Add left padding
```

Reload the tmux environment (`$ tmux source-file ~/.tmux.conf`) after saving
your changes.

### Special Credit

This plugin is roughly based on the various plugins in the [tmux-plugins](https://github.com/tmux-plugins) organisation.

### Maintainer

- [Miriam Yumi](https://github.com/yumiriam)

### License

[MIT](LICENSE.md)

