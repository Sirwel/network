#!/bin/bash

$opt
$fname
$path

printf "This shell script will allow you to capture network traffic.\n\n"
printf ""

while [ -z $fname ]
	do
		printf "Enter a name for file where network traffic will be saved:\n"
		read fname
		
	done

while [ -z $path ]
	do
	
		printf "\n\nEnter an existing absolute path to a directory for saving the file following this structure: /home/user/my_directory.\n "
		printf "Otherwise, a directory will be crated following the path you provided: \n"
		read path 	
	
		if [ -d $path ]
		then
	
			printf " the route is valid. Preceding with the caputure. \n\n"
		
		else
		
			mkdir $path 
		
		
    		
		if [ $? -ne "0" ] 
		then	
		
			printf "The directory could not be crated in that path. Check the path structure for non existing directories. \n"
		
		else 
			printf " The directory was created. the directory is $path  \n"
			chmod +777 -R +ugo $path

		fi			
	
	fi

	done

printf "The capture of network traffic will begin. \n"
printf "The capure is in procress. You can now generate some traffic. For stopping the capure and generating files for analysis type \"stop\"  \n"


tshark -T fields -e frame.number -e ip.src -e ip.dst -e frame.len -e tcp.window_size -e tcp.analysis.ack_rtt -e _ws.col.Protocol -e tcp.ack -e tcp.seq -e tcp.analysis.bytes_in_flight -e tcp.analysis.retransmission -E header=y -E separator=, -E quote=d -E occurrence=f > $path/$fname.csv

#end










