#!/bin/bash

#1	source
#2	destination	
#3	syn
#4	ack
#5	seq
#6	urg
#7	push
#8	fin	
#9	reset
#10	protocol
#11	src port	
#12 `	dst port

while read capture; 
do

awk -v awk_cap="$capture" '
BEGIN {FS = "\t"; };

#body
$10 == "TCP"{ 

	if ($9 == 1 && $5 == 1 && $4 == 0  ){ print "Syn scan was Detected. Source ip"$1"| Destination IP: "$2". Destination port: "$11" \n" }else 
	if ($3 == 0 && $4 == 0  && $6 == 0 && $7 == 0 && $8 == 0 && $9 == 0) { print "Null scan was Detected. Source ip"$1"| Destination IP: "$2". 		Destination port: "$11" \n" } else
	if ($3 == 0 && $4 == 0 && $6 == 1 && $7 == 1 && $8 == 1 && $9 == 0) { print "Xmas scan was Detected. Source ip"$1"| Destination IP: "$2". 		Destination port: "$11" \n"} else
	if ($3 == 0 && $4 == 0  && $6 == 0 && $7 == 0 && $8 == 1 && $9 == 0) { print "Fin scan was Detected. Source ip"$1"| Destination IP: "$2". 		Destination port: "$11" \n" }  


}

'

done < <(tshark -l -Q -T fields -e ip.src -e ip.dst -e tcp.flags.syn -e tcp.flags.ack -e tcp.seq -e tcp.flags.urg -e tcp.flags.push -e tcp.flags.fin -e tcp.flags.reset -e _ws.col.Protocol -e tcp.dstport)








