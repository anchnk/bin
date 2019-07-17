#! /usr/bin/env bash

save_firefox_profile_to_dropbox() {
  local firefox_profile_path
  local today
  local archive_path

  firefox_profile_path="$HOME/.mozilla/firefox/lzvmqt6n.default"
  today=$(date +%d-%m-%Y)
  archive_directory="/tmp/$today"
  archive_path="$archive_directory/firefox-browser-profile.tar.bz2"
  encrypted_archive_path="$archive_path.gpg"

  mkdir -p "$archive_directory"
  tar -jcvf "$archive_path" "$firefox_profile_path"
  gpg -c "$archive_path"
  rclone copy "$encrypted_archive_path" dropbox:Backups/"$today"

  rm -r "$archive_directory"
}

save_firefox_profile_to_dropbox
