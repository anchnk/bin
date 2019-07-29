#!/bin/sh

nerd_fonts_dir=$HOME/code/public/nerd-fonts

create_user_font_dir() {
  user_font_dir=$HOME/.local/share/fonts

  if [ ! -d "$user_font_dir" ]; then
    mkdir -p "$user_font_dir" || {
      echo "Failed to create user font directory"
      exit 1
    }
  fi
}

clone_nerd_fonts_repo() {
  if [ -d "$nerd_fonts_dir" ]; then
    rm -rf "$nerd_fonts_dir"
  fi

  git clone https://github.com/ryanoasis/nerd-fonts.git "$nerd_fonts_dir" || {
    echo "Failed to clone nerd-fonts repo"
    exit 1
  }
}

checkout_latest_tag() {
  cd "$nerd_fonts_dir" || {
    echo "Failed to change current directory"
    exit 1
  }

  tag_name=$(git describe --abbrev=0 --tags)
  echo "Checking out $tag_name tag"
  git checkout tags/"$tag_name"
}

install_nerd_fonts() {
  nerd_fonts_dir=$HOME/code/public/nerd-fonts
  "$nerd_fonts_dir/install.sh" -O
}

create_user_font_dir
clone_nerd_fonts_repo
checkout_latest_tag
install_nerd_fonts
