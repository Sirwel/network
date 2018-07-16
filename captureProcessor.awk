#/bin/bash

BEGIN {
FS= ","
OFS=","


ipC=0;

}

#check if an IP address exist in list before adding it to the report
function inList(ipD, iplist){

	for( h = 0; h<=NR; h++){
		
		if (ipD == iplist[h,0]) {
		b = h;
		
			break;

		}else	{

		b = "no";
	
		}
	}

return b;
}	


function retransmission(ret){

	if (ret != ""){ 
	retC+=1;

		}


return retC;
}




#0= index ip addresses 
#1= windoes size
#2 = round trip time
#3 = windows size accumulator
#4=  round trip time accumulator
#5 = number of retransmissions
#6=  packet size
#7=  packet counter
substr($7,2,length($7)-2) == "TCP" {

i= inList($3,iplist);

	if (  i == "no" ) {
		iplist[ipC,0]=$3;
		iplist[ipC,1]=substr($5,2,length($5)-2);
		iplist[ipC,2]=substr($6,2,length($6)-2);
		iplist[ipC,3]+=1;
		iplist[ipC,4]+=1;
		iplist[ipC,6]+=substr($4,2,length($4)-2);
		iplist[ipC,7]+=1;
		#print "new ip saved.the ip is:"iplist[ipC,0]"the win size  is :"iplist[ipC,1]" round trip :" iplist[ipC,2];
		
		if ($11 != "" ) iplist[ipC,5]+=1;		

		
		ipC++;

		} else {
				
		iplist[i,1]+=substr($5,2,length($5)-2);
		iplist[i,2]+=substr($6,2,length($6)-2);
		iplist[i,3]+=1;#win size counter
		iplist[i,4]+=1;#rtt counter
		iplist[ipC,6]+=substr($4,2,length($4)-2);
		iplist[ipC,7]+=1;

		if ($11 != "" ) iplist[ipC,5]+=1;
		
		#print "The ip is:"iplist[i,0]"the cumulative win size  is :"iplist[i,1]" commulative round trip :" iplist[i,2];

				}	
	

}


END{

	for (a = 0; a < ipC; a++){
		
	
	print "---------------------------------------Results----------------------------------\n\n"
	print "Host" iplist[a,0]
	print "The average window size is: " (((iplist[a,1]*8)/iplist[a,3])/1500*8)" bits. \n";
	print "The average roundtrip time is: " (iplist[a,2]/iplist[a,4])"  \n";
	print "The total data load was: "(iplist[a,6]/1024)/1024" Megabytes  .\n"

	if (iplist[a,5] != "" ){	
	
	print "the percentage of error was "iplist[a,5]/iplist[a,7]"%. \n"


		} else {  

	print "No significant transmission errors happened. \n"

}
	
	
	wn= (((iplist[a,1]*8)/iplist[a,3])/(1500*8));
	rt= iplist[a,2]/iplist[a,4];

	if (rt !=0 ) {
	print "the host throughput is:"(wn*rt)/1000000" Megabits/.sec \n\n" 
	}else {

	print" either the windows size or the latency is 0. Therefore, not important data exchange happend.\n\n"

	}


	windowZ+=iplist[a,1]*8;
	windowC+=iplist[a,3];
	

	roundTC+=(iplist[a,2]);
	roundC+= (iplist[a,4]);
	
	retrasmT+= iplist[a,5];
	trafficT+= iplist[a,7];
	
	}

	print "-----------------------Network Results-------------------------------\n\n"
	print "The overall throughput of the network is: "((windowZ/windowC)/(1500*8))*(roundTC/roundC)/1000000" Megabits/sec \n\n"
	print "The error rate during the transmission for all the devices in the network "retrasmT/trafficT" % of packet loss \n\n"
}








