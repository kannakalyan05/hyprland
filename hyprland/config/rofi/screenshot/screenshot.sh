#!/usr/bin/env bash

# Import Current Theme
theme="~/.config/rofi/screenshot/style.rasi"

# Theme Elements
prompt='Screenshot'
mesg="DIR: $HOME/Pictures/Screenshots"
list_col='5'
list_row='1'
win_width='670px'
option_1=""
option_2=""
option_3=""
option_4=""
option_5=""

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$HOME/Pictures/Screenshots"
file="Screenshot_${time}.png"

if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

# Take the screenshot
shotnow () {
    hyprshot -t 1000 -m output -c -o "$dir" -f "$file"
}

shotwin () {
  hyprshot -t 1000 -m window -c -o "$dir" -f "$file"
}

shotarea () {
  hyprshot -t 1000 -m region -o "$dir" -f "$file"
}

shot5 () {
  sleep 5
  hyprshot -t 1000 -m output -c -o "$dir" -f "$file"
}

shot10 () {
  sleep 10
  hyprshot -t 1000 -m output -c -o "$dir" -f "$file"
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		shot10
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac
