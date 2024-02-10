#!/usr/bin/env bash

# Import Current Theme
theme="~/.config/rofi/screenshot/style.rasi"

# Theme Elements
mesg="~/Pictures/Screenshots"
list_col='1'
list_row='5'
win_width='250px'
option_1="󰍹  Monitor"
option_2="󰨇  Active window"
option_3="󰹑  Crop "
option_4="󰎰  Monitor 5 sec"
option_5="󰼓  Active 5 sec"
# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
		-mesg "$mesg" \
		-theme ${theme}
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u normal "Screenshot saved"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$HOME/Pictures/Screenshots"
file="Screenshot_${time}.jpeg"

if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

# Take the screenshot
shotnow () {
  sleep 1
  grim -t jpeg "$dir/$file" && notify_user
}

shotwin () {
  sleep 1
  hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -t jpeg -g - "$dir/$file" && notify_user
}

shotarea () {
  slurp | grim -t jpeg -g - "$dir/$file" && notify_user
}

shotnow5 () {
  sleep 5
  grim -t jpeg "$dir/$file" && notify_user
}

shotwin5 () {
  sleep 5
  hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -t jpeg -g - "$dir/$file" && notify_user
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotwin
	elif [[ "$1" == '--opt3' ]]; then
		shotarea
	elif [[ "$1" == '--opt4' ]]; then
		shotnow5
	elif [[ "$1" == '--opt5' ]]; then
		shotwin5
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
