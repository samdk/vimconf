#!/bin/bash

set -e -u -o pipefail

cd "$(dirname "$0")"
./do_backups.sh dropbox   /media/disk_main/Dropbox
./do_backups.sh documents /home/samdk/Documents

