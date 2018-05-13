#!/bin/bash
set -e -u -o pipefail

backup_basedir=/media/disk_backup/backups
expected_count=2

ok_count=0
total_count=0

for backup_dir in $(find "$backup_basedir" -mindepth 1 -maxdepth 1 -type d -not -name 'log'); do
  total_count=$(( $total_count + 1 ))
  log_dir="${backup_dir}/log"
  recent_log_count=0
  most_recent_success=0
  for recent_log_file in $(find "$log_dir" -mindepth 1 -maxdepth 1 -type f -name "*.log"); do
    recent_log_count=$(( $recent_log_count + 1 ))
    last_line="$(tail -n 1 "$recent_log_file")"
    if [[ "$last_line" =~ [0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}\+[0-9]{2}:00 ]]; then
      log_timestamp=$(date -d "$(echo "$last_line" | cut -d ' ' -f 1-2)" +%s)
      log_message=$(echo "$last_line" | cut -d ' ' -f 4-)
      if [[ "$log_message" = "snapshot backup finished successfully" ]]; then
        if [[ "$log_timestamp" -gt "$most_recent_success" ]]; then
          most_recent_success="$log_timestamp"
        fi
      fi
    fi
  done
  if [[ "$recent_log_count" -gt 10 && "$most_recent_success" -gt "$(date -d 'now - 2 hours' +%s)" ]]; then
    ok_count=$(( $ok_count + 1 ))
  fi
done

failed_count=$(( "$total_count" - "$ok_count" ))

if [[ "$#" = 1 && "$1" = "-write" ]]; then
  if [[ "$total_count" = "$expected_count" && "$total_count" = "$ok_count" ]]; then
    date +%s > ~/.last_backup_time
  fi
else
     RED="$(tput setaf 1)"
   GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  result="UNDEFINED"
  if [[ "$failed_count" -gt 0 ]]; then
    result="${RED}${ok_count} ok, ${failed_count} failed"
  else
    if [[ "$total_count" = "$expected_count" ]]; then
      result="${GREEN}$total_count ok"
    else
      result="${YELLOW}$total_count ok, expected $expected_count"
    fi
  fi
  echo "backups: ${result}$(tput sgr0)"
fi

