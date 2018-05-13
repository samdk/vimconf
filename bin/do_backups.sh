#!/bin/bash

set -e -u -o pipefail

if [[ "$#" != 2 ]]; then
  echo "usage: $0 <label> <folder-to-back-up>"
  exit 1
fi

# rsync snapshot backups with hard links

backup_basedir=/media/disk_backup/backups/
global_log_dir="${backup_basedir}/log"

mkdir -p "$backup_basedir"
mkdir -p "$global_log_dir"

global_log_file="${global_log_dir}/$(date +"%Y-%m-%d").log"

annotated_echo() {
  echo "$(date +"%Y-%m-%d %H:%M:%S%:z") $(whoami): $@" 
}

global_log_msg() {
  annotated_echo "$@" | tee -a "$global_log_file"
}

global_log_msg "running with args=[$@]"

make_snapshot() {
  backup_label="$1"
  src_dir="$2"

  dst_basedir="${backup_basedir}/${backup_label}"
  log_dir="${dst_basedir}/log"
  latest_backup="${dst_basedir}/latest"

  if [[ ! -e "$dst_basedir" ]]; then
    echo "this folder has not been backed up before:"
    echo
    echo "label=${backup_label}"
    echo "src=[$src_dir]"
    echo "dst=[$dst_basedir]"
    echo
    read -p "set up this folder for backup? [y/n]:" yn
    case "$yn" in
      [Yy] )
        echo "doing initial snapshot setup"
        global_log_msg "setting up new backup location [${backup_label}=${src_dir}]"
        # set up base and log directories"
        mkdir -p "$dst_basedir"
        mkdir "$log_dir"

        # set up an initial 'latest backup' symlink pointing at ~/.init
        init_dir=".init"
        mkdir "$init_dir"
        ln -s "$init_dir" "$latest_backup"
        break
        ;;
      * )
        echo "doing nothing"
        exit 1
        ;;
    esac
  fi

  snapshot_time="$(date +"%Y-%m-%d_%H-%M-%S%z")"
  log_file="${log_dir}/${snapshot_time}.log"

  log_msg() {
    annotated_echo "$@" | tee -a "$log_file"
  }

  dst_dir="${dst_basedir}/${snapshot_time}"

  if [[ -e "$dst_dir" ]]; then
    log_msg "destination directory [$dst_dir] already exists, something is wrong, exiting" 1>&2
  	exit 1
  fi

  log_msg "running backup"

  log_msg "latest_backup=[$latest_backup]"
  log_msg "src_dir=[$src_dir]"
  log_msg "dst_dir=[$dst_dir]"

  log_msg "starting rsync"
  set -x
  rsync -avh --link-dest="$latest_backup" "$src_dir" "$dst_dir" | tee -a "$log_file"
  set +x

  log_msg "rsync finished, updating symlink"

  # ln -sf isn't atomic, mv is
  tmp_latest_backup="${latest_backup}.tmp"
  # we link to the relative dir so the links still work if we end up moving
  # files around
  ln -s "$(basename "$dst_dir")" "$tmp_latest_backup"
  mv -T "$tmp_latest_backup" "$latest_backup"

  log_msg "snapshot backup finished successfully"
}

make_snapshot "$1" "$2"

