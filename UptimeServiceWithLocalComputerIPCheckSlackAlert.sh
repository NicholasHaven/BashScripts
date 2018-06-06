#!/bin/sh
###put IP addresses in this field, space delimited
server=( 127.0.0.1 )
###This finds your public IP
ipaddy=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/    <.*$    //')
### Muliple IPs can be specified
if [[ $ipaddy == "YourIPaddress"*  ||  $ipaddy == "YourOtherIPaddress"* ]] > /dev/null ; then 
#echo $ipaddy
for i in "${server[@]}" ; do
###This checks to see if cron is running, Change Key
if ssh -qn root@$i  -o IdentityFile='/Path/To/Key' "service crond status | grep running" > /dev/null ; then
	#uncomment out the line below while testing
	#echo "Turned on"
	:
else
	#uncomment out the line below while testing
	#echo "Not Turned on"
	###Change Key
	ssh -qn root@$i  -o IdentityFile='/Path/To/Key' "service crond start"
	### Slack Notification
	curl -X POST --data-urlencode 'payload={"channel": "#ChannelName", "YourSlackUserName": "webhookbot", "text": "Cron was turned on for '$i'", "icon_emoji": ":tada:"}' https://hooks.slack.com/services/hookID/HookIDtag
fi
	wait
done
fi
