#!/bin/bash

set -eu -o pipefail

ZIPPED_ARCHIVE_LOCATIONS=(/media/diskstation/MUSIC_ARCHIVE/)
UNZIPPED_ARCHIVE_LOCATIONS=(/media/diskstation/MUSIC_UNZIPPED/ /media/disk_main/Dropbox/music/)
LOSSY_ARCHIVE_LOCATIONS=(/media/diskstation/MUSIC_LOSSY/)

if [[ "$#" != 1 ]]; then
  echo "usage: $0 <music_archive.zip>"
  exit 1
fi

ZIP_NAME="$1"

set -x

SCRATCH_DIR=archive-music-tmp
FOLDER_BASENAME="$(basename "$ZIP_NAME" | sed -r 's#\.zip$##')"

lossy_folder_name() {
  echo "$1" | sed -r 's#/RAW/#/LOSSY/#'
}
export -f lossy_folder_name

RAW_FOLDER_NAME="${SCRATCH_DIR}/RAW/${FOLDER_BASENAME}"
LOSSY_FOLDER_NAME="$(lossy_folder_name "$RAW_FOLDER_NAME")"

echo "$ZIP_NAME"
echo "$RAW_FOLDER_NAME"
echo "$LOSSY_FOLDER_NAME"

mkdir "$SCRATCH_DIR"
mkdir -p "$RAW_FOLDER_NAME"
mkdir -p "$LOSSY_FOLDER_NAME"

unzip -d "$RAW_FOLDER_NAME" "$ZIP_NAME"

copy_or_transcode() {
  local old_path="$1"
  old_dir="$(dirname "$old_path")"
  old_file="$(basename "$old_path")"
  ext="$(echo "$old_file" | sed -r 's#^.+\.([^.]+)$#\1#')"
  new_dir=$(lossy_folder_name "$old_dir")
  mkdir -p "$new_dir"
  if [[ "$ext" = "flac" ]]; then
    new_path="${new_dir}/$(echo "$old_file" | sed -r 's#\.flac$#.opus#')"
    # lossless music gets transcoded into 128k opus
    ffmpeg -i "$old_path" -acodec libopus -b:a 128k -compression_level 10 -vbr on "$new_path"
  else
    # everything else just gets copied over
    cp "$old_path" "$new_dir/"
  fi
}
export -f copy_or_transcode

find "$RAW_FOLDER_NAME" -type f -print0 \
  | xargs -0 -P 3 -I {} bash -c 'set -eux -o pipefail; copy_or_transcode "$@"' _ {}

export IFS=$'\n'

compute_sha1() {
  sha1sum "$1" | awk '{print $1}'
}

for location in "${ZIPPED_ARCHIVE_LOCATIONS[@]}"; do
  cp "$ZIP_NAME" "$location/"

  expected_new_name="$location/$(basename "$ZIP_NAME")"
  old_sha1="$(compute_sha1 "$ZIP_NAME")"
  new_sha1="$(compute_sha1 "$expected_new_name")"
  if [[ "$old_sha1" != "$new_sha1" ]]; then
    echo "copying zip file did not complete successfully"
    echo "old file: $ZIP_NAME"
    echo "new file: $expected_new_name"
    echo "old sha1: $old_sha1"
    echo "new sha1: $new_sha1"
    exit 1
  fi
done

for location in "${UNZIPPED_ARCHIVE_LOCATIONS[@]}"; do
  cp -r "$RAW_FOLDER_NAME" "$location/"
done

for location in "${LOSSY_ARCHIVE_LOCATIONS[@]}"; do
  cp -r "$LOSSY_FOLDER_NAME" "$location/"
done

rm -r "$RAW_FOLDER_NAME"
rm -r "$LOSSY_FOLDER_NAME"

rmdir "$SCRATCH_DIR"/{RAW,LOSSY}
rmdir "$SCRATCH_DIR"

mkdir -p archived
mv -b "$ZIP_NAME" archived/

