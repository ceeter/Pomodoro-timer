#!/bin/bash

date1=$((`date +%s` + $1));
figlet "$(date -u --date @$(($date1 - `date +%s`)) +%M:%S)" > .p.txt;
file=.p.txt
lines=0
y=$(( ($(tput cols) - $(sed '1q;d' $file | wc -c)) / 2))

# finds how many rows the file contains
while IFS= read -rN1 char; do
	if [[ "$char" == $'\n' ]]; then
		((++lines))
	fi
done < "$file"

while [ True ]; do
	date1=$((`date +%s` + $1));
	row=$(( ($(tput lines) - $lines) / 2))
	col=$y
	temp=$row
	while [ "$date1" -ge `date +%s` ]; do
		tput clear

		figlet "$(date -u --date @$(($date1 - `date +%s`)) +%M:%S)" > .p.txt;
		
		for (( i=1; i<$lines; ++i)); do
			tput cup $row $col
			sed "${i}q;d" $file
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

