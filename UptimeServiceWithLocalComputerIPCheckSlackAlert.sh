#!/bin/sh
server=( 127.0.0.1 ) ###put IP addresses in this field, space delimited
ipaddy=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/    <.*$    //') ###This finds your public IP
if [[ $ipaddy == "YourIPaddress"*  ||  $ipaddy == "YourOtherIPaddress"* ]] > /dev/null ; then ### Muliple IPs can be specified 
#echo $ipaddy
for i in "${server[@]}" ; do
if ssh -qn root@$i  -o IdentityFile='/Path/To/Key' "service crond status | grep running" > /dev/null ; then ###This checks to see if cron is running
	#uncomment out the line below while testing
	#echo "Turned on"
	:
else
	#uncomment out the line below while testing
	#echo "Not Turned on"
	#comment out the below line while server is being maintenced##
	ssh -qn root@$i  -o IdentityFile='/Path/To/Key' "service crond start"
	curl -X POST --data-urlencode 'payload={"channel": "#ChannelName", "YourSlackUserName": "webhookbot", "text": "Cron was turned on for '$i'", "icon_emoji": ":tada:"}' https://hooks.slack.com/services/hookID/HookIDtag
fi
	wait
done
fi
