#! /usr/bin/env bash

firefox_folder="$HOME/.mozilla/firefox/"

get_firefox_profile_name() {
  local firefox_profiles_ini="$firefox_folder/profiles.ini"
  local firefox_profile_name

  # Fetch firefox default profile name
  firefox_profile_name=$(awk -F '=' 'NR==2,/Default/{ print $2 }' "$firefox_profiles_ini")
  echo "$firefox_profile_name"
}

save_firefox_profile_to_dropbox() {
  local firefox_profile_path
  local today
  local archive_path

  firefox_profile_path="$firefox_folder"$(get_firefox_profile_name)
  today=$(date +%d-%m-%Y)
  archive_directory="/tmp/$today"
  archive_path="$archive_directory/firefox-browser-profile.tar.bz2"
  encrypted_archive_path="$archive_path.gpg"

  echo "$archive_path"
  echo "$firefox_profile_path"
  mkdir -p "$archive_directory"
  tar -jcvf "$archive_path" "$firefox_profile_path"
  gpg -c "$archive_path"
  rclone copy "$encrypted_archive_path" dropbox:Backups/Bookmarks/"$today"
  rm -r "$archive_directory"
}

save_firefox_profile_to_dropbox
