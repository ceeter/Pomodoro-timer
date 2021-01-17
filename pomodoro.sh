#!/bin/bash

while [ True ]; do
	
	# current terminal total number of columns
	termcol=$(tput cols)
	# current terminal total number of lines
	termlin=$(tput lines)
	
	# formats the timer to min:sec, depending on $1 in seconds
	time=$((`date +%s` + $1));
	# temp holder, formats timer into figlet style
	msg=$(figlet -k "$(date -u --date @$(($time - `date +%s`)) +%M:%S)")
	# integer value of total char len of figlet msg
	msglen=$(( $(echo "$msg" | head -n 1 | wc -c) - 1))
	# integer value of total number of lines in figlet msg
	msglin=$(printf "$msg" | wc -l)
	# row number for msg to be printed in center of term
	mrow=$(( ($termlin - $msglin) / 2))

	# msg to display after timer ends
	prompt="Press <ENTER> to restart timer"
	# row to print prompt in center of term
	prow=$(( ($termlin - 1) / 2))
	# col to print prompt in center of term
	pcol=$(( ($termcol - $(echo $prompt | wc -c) + 2) / 2))
	
	# timer
	while [ "$time" -ge `date +%s` ]; do
		tput clear
		tput cup $mrow
		comp=$(( $termcol - ( $msglen - $(figlet -k "$(date -u --date @$(($time - `date +%s`)) +%M:%S)" | head -n 1 | wc -c) - 1)))
		figlet -ctk -w $comp "$(date -u --date @$(($time - `date +%s`)) +%M:%S)"
		sleep 1
	done
	
	# system notification
	notify-send "Pomodoro" "5 min pause!" -u critical -i emote-love -t 5000
	# audio played along with notification
	play /home/zacter/Music/pomodoro.wav > /dev/null 2>&1 & 
	
	# prompt
	tput clear
	tput cup $prow $pcol
	echo "$prompt"
	tput cup $(( $prow + 1)) $(( ($termcol - 1) / 2))
	
	# restart timer prompt, listens for ENTER
	while [ True ]; do
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
		echo -ne "\b\b\b   \b\b\b"
	done
done

