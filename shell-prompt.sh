#! /usr/bin/env bash

# abort if we're already inside a TMUX session
#[ "$TMUX" == "" ] || exit 0
# startup a "default" session if non currently exists
# tmux has-session -t _default || tmux new-session -s _default -d

# present menu for user to choose which workspace to open

function prompt_headline() {
  local USER=get_current_user
  echo "Welcome `whoami`," `date '+%a%e/%m/%y %k:%M'`
}

PROMPT_HEADLINE=$(prompt_headline)

function draw_separator() {
  PROMPT_HEADLINE_LENGTH=${#PROMPT_HEADLINE}
  printf '%.s-' {1..35}
}

function draw_menu() {
  local POS=0
  local CURRENT_LINE=0
  COLUMNS=$(tput cols)
  LINES=$(tput lines)
  X=$(( ( $LINES - 0 ) / 2 ))
  Y=$(( ( $COLUMNS - 35 ) / 2 ))

  options=($(tmux list-sessions -F "#S" 2>/dev/null) "Start a new tmux session" "Start a bash shell" "Exit")

  tput clear
  tput cup $X $Y
  CURRENT_LINE=$X
  prompt_headline
  ((CURRENT_LINE++))

  tput cup $CURRENT_LINE $Y
  draw_separator
  ((CURRENT_LINE++))

  for ((i=0;i<${#options[@]};i++)); do
    local DISPLAY_INDEX=$(( $i + 1 ))
    tput cup $CURRENT_LINE $Y
    echo "$DISPLAY_INDEX) ${options[$i]}"
    ((CURRENT_LINE++))
  done

  tput cup $CURRENT_LINE $Y
  draw_separator
  ((CURRENT_LINE++))

  tput cup $CURRENT_LINE $Y
  read -p 'What would you like to start with ? ' opt
  case $opt in
    2)
      read -p "Enter new session name: " SESSION_NAME
      tmux new -s "$SESSION_NAME"
      break;;
    3)
      tput clear
      bash --login
      ;;
    4)
      break
      ;;
  esac
}

draw_menu
