#! /usr/bin/env bash

# abort if we're already inside a TMUX session
#[ "$TMUX" == "" ] || exit 0
# startup a "default" session if non currently exists
# tmux has-session -t _default || tmux new-session -s _default -d

# present menu for user to choose which workspace to open

function prompt_headline() {
  echo "Welcome $(whoami), $(date '+%a%e/%m/%y %k:%M')"
}

prompt_headline=$(prompt_headline)

function draw_separator() {
  local headline_length=${#prompt_headline}
  printf '%*s' "$headline_length" "" | tr ' ' -
}

function draw_menu() {
  local current_line=0
  COLUMNS=$(tput cols)
  LINES=$(tput lines)
  x=$(( ( LINES - 0 ) / 2 ))
  y=$(( ( COLUMNS - 35 ) / 2 ))

  options=($(tmux list-sessions -F "#S" 2>/dev/null) "start a new tmux session" "start a bash shell" "exit")

  tput clear
  tput cup $x $y
  current_line=$x
  prompt_headline
  ((current_line++))

  tput cup $current_line $y
  draw_separator
  ((current_line++))

  for ((i=0;i<${#options[@]};i++)); do
    local DISPLAY_INDEX=$(( i + 1 ))
    tput cup $current_line $y
    echo "$DISPLAY_INDEX) ${options[$i]}"
    ((current_line++))
  done

  tput cup $current_line $y
  draw_separator
  ((current_line++))

  tput cup $current_line $y
}

function compute_menu_indexes() {
  local tmux_sessions_number
  tmux_sessions_number=$(tmux ls | wc -l)

  tmux_new_session_index=$((tmux_sessions_number + 1))
  bash_shell_index=$((tmux_new_session_index + 1))
  exit_index=$((bash_shell_index + 1))
}

while draw_menu;
  compute_menu_indexes
  echo "${options[1]}"
  read -p 'What would you like to start with ? ' opt
  do case $opt in
    $tmux_new_session_index)
      tput clear
      read -p "Enter new session name: " session_name
      tmux new -s "$session_name"
      ;;
    $bash_shell_index)
      tput clear
      bash --login
      ;;
    $exit_index)
      break
      ;;
  esac
done
