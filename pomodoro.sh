#!/bin/bash

while [ True ]; do
	time=$((`date +%s` + $1));
	msg=$(figlet "$(date -u --date @$(($time - `date +%s`)) +%M:%S)")
	lines=$(echo "$msg" | wc -l)
	row=$(( ($(tput lines) - $lines) / 2))
	col=$(( ($(tput cols) - $(echo "$msg" | head -n 1 | wc -c)) / 2))
	temp=$row
	while [ "$time" -ge `date +%s` ]; do
		tput clear
		
		msg=$(figlet "$(date -u --date @$(($time - `date +%s`)) +%M:%S)")

		for (( i=1; i<$lines; ++i)); do
			tput cup $row $col
			printf "$msg" | sed "${i}q;d"
			((++row))
		done
		
		row=$temp
		sleep 1
	done
	
	notify-send "Pomodoro" "5 min pause!"  -u critical -i emote-love -t 5000

	play /home/zacter/Music/pomodoro.wav > /dev/null 2>&1 & 
	
	prompt="Press <ENTER> to restart timer"
	
	row=$(( ($(tput lines) - 1) / 2))
	col=$(( ($(tput cols) - $(echo $prompt | wc -c) + 2) / 2))
	dotc=$(( ($(tput cols) - 1) / 2))	
	dotr=$(( $row + 1))

	while [ True ]; do
		tput clear
		tput cup $row $col
		echo "$prompt"
		tput cup $dotr $dotc
		echo -n "."
		read -t 1 
		if [ $? = 0 ]; then
			break ;
		fi
		echo -n "."
		read -t 1 
	 	if [ $? = 0 ]; then
			break ;
		fi	
		echo -n "."
		read -t 1 
		if [ $? = 0 ]; then
			break ;
		fi
	done
done

