#!/bin/bash

GATEWAYIP=10.1.20.193
SID=$(curl --connect-timeout 10 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | jq '.body.sid' | tr -d '"')
#echo "${SID//'"'}"
#SID=$(curl --connect-timeout 10 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | jq '[.[] ]') 
#SID=$(curl --connect-timeout 10 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | jq '{sid: .response.body.sid }')
     
#grep 'sid')

#| sed -n -e 's/^.........//p')


#MODEL=$(curl --connect-timeout 10 -X POST -d "request=P89&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.get | jq '.body.P89' | tr -d '"' | head -c-7)
#VERSION=$(curl --connect-timeout 10 -X POST -d "request=P68&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.get | jq '.body.P68' | tr -d '"')

MODEL=$(curl --connect-timeout 10 -X POST -d "request=P89&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.get | jq '.body.P89' | tr -d '"' | head -c-8)
VERSION=$(curl --connect-timeout 10 -X POST -d "request=P68&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.get | jq '.body.P68' | tr -d '"')

echo "Session ID: $SID"

echo "Model: $MODEL"
echo "Software Version: $VERSION"

TEST1=$(curl --connect-timeout 10 -X POST -d "P8=1&P9=192&P10=168&P11=3&P12=200&P15=255&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post | jq '.response')

echo "$TEST1"

