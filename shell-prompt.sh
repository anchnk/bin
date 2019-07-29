#! /usr/bin/env bash

# abort if we're already inside a TMUX session
#[ "$TMUX" == "" ] || exit 0
# startup a "default" session if non currently exists
# tmux has-session -t _default || tmux new-session -s _default -d

# present menu for user to choose which workspace to open

prompt_headline() {
  echo "Welcome $(whoami), $(date '+%a%e/%m/%y %k:%M')"
}

get_tmux_sessions_number() {
  tmux ls 2>/dev/null | wc -l
}

tmux_sessions_number=$(get_tmux_sessions_number)

draw_separator() {
  local headline_length=${#prompt_headline}
  local separator_length=$(( headline_length + 2))
  printf '%*s' "$separator_length" "" | tr ' ' -
}

draw_menu() {
  current_line=0
  columns=$(tput cols)
  lines=$(tput lines)
  x=$(( ( lines - 0 ) / 2 ))
  y=$(( ( columns - 35 ) / 2 ))

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
  local dynamic_menu_items_number
  dynamic_menu_items_number=$(get_tmux_sessions_number)

  tmux_new_session_index=$((dynamic_menu_items_number + 1))
  bash_shell_index=$((tmux_new_session_index + 1))
  exit_index=$((bash_shell_index + 1))
}

tmux_attach_session() {
  local session_name=$1
  tmux attach-session -t "$session_name"
}

tmux_start_new_session() {
  tput clear
  read -p "Enter new session name: " session_name
  tmux new -s "$session_name"
}

bash_login() {
  tput clear
  bash --login
}

prompt_headline=$(prompt_headline)
while draw_menu;
  compute_menu_indexes
  read -p 'What would you like to start with ? ' opt
  do
    if [ "$opt" -le "$tmux_sessions_number" ];
    then
      echo "${options[((opt - 1))]}"
      tmux_attach_session "${options[((opt - 1))]}"
    else
      case $opt in
        $tmux_new_session_index)
          tmux_start_new_session
          ;;
        $bash_shell_index)
          bash_login
          ;;
        $exit_index)
          break
          ;;
      esac
    fi
    break
done
