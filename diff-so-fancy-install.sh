#!/bin/sh

diff_so_fancy_repo=$public_repos/diff-so-fancy

clone_or_update_git_repo() {

  if [ ! -d $diff_so_fancy_repo ]; then
    git clone https://github.com/so-fancy/diff-so-fancy $public_repos/diff-so-fancy
  else
    cd $diff_so_fancy_repo
    git fetch origin
    git rebase
  fi

}

link_to_bin_folder() {

  cd $bin
  if [ -L diff-so-fancy ];then
    rm diff-so-fancy
  fi
  ln -s $diff_so_fancy_repo/diff-so-fancy diff-so-fancy

}

clone_or_update_git_repo
link_to_bin_folder
