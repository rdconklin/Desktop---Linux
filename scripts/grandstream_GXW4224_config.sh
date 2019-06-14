#!/bin/bash

##############################################
##                                          ##
## GRANDSTREAM GXW4224 Configuration Script ##
##                                          ## 
##############################################

echo "Finding Grandstream"
#GATEWAYIP=$(nmap -p23 --open 10.1.20.120-254 | grep -o "10.1.20.*")
#GATEWAYIP=192.168.3.200

#
#UPDATE GATEWAYIP BEFORE EXECUTING SCRIPT
#
GATEWAYIP=10.1.20.193
echo "Grandstream IP: $GATEWAYIP"

echo "Login to Grandstream"
echo "Finding SID"
#Find and parse out Session ID
#SID=$(curl --connect-timeout 5 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | grep -o 'sid" : .............' | tail -c 13)
#SID=$(curl --connect-timeout 10 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | grep -o 'sid" : ..............' | tail -c 18 | grep -o '"[^"]*"' | sed -e 's/[^[:alnum:]|-]//g')
SID=$(curl --connect-timeout 10 -X POST -d "username=admin&password=changeme" http://$GATEWAYIP:30005/cgi-bin/dologin | grep -o 'sid" : ............' | tail -c 12)
echo "SID: $SID"

echo "Set IP"
#Sets IP for the Grandstream
#1st Grandstream on a TRIAD = 192.168.3.201
#2nd Grandstream on a TRIAD = 192.168.3.202
#3rd Grandstream etc....
curl --connect-timeout 10 -X POST -d "P8=1&P9=192&P10=168&P11=3&P12=200&P15=255&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api.values.post

echo ""
echo "Disable telnet, change admin port, set password"
#Disables telnet and updates admin settings
curl --connect-timeout 10 -X POST -d "P901=30005&P276=1&P2=changeme&:confirmAdminPwd=changeme&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api.values.post

echo ""
echo "Profile 1 SIP settings set # key behaviour for transfer feature"
#Sets behavior of # when calling, allows for call transfer
curl --connect-timeout 10 -X POST -d "P1406=1&P72=0&P47=192.168.3.100&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api.values.post

echo ""
echo "FXS settings 1-24"
#Set the default valuse for each SIP channel 1001-1024

curl --connect-timeout 10 -X POST -d "P4060=1001&P4090=1001&P4120=1001&P4180=1001&P4061=1002&P4091=1002&P4121=1002&P4181=1002&P4062=1003&P4092=1003&P4122=1003&P4182=1003&P4063=1004&P4093=1004&P4123=1004&P4183=1004&P4064=1005&P4094=1005&P4124=1005&P4184=1005&P4065=1006&P4095=1006&P4125=1006&P4185=1006&P4066=1007&P4096=1007&P4126=1007&P4186=1007&P4067=1008&P4097=1008&P4127=1008&P4187=1008&P4068=1009&P4098=1009&P4128=1009&P4188=1009&P4069=1010&P4099=1010&P4129=1010&P4189=1010&P4070=1011&P4100=1011&P4130=1011&P4190=1011&P4071=1012&P4101=1012&P4131=1012&P4191=1012&P4072=1013&P4102=1013&P4132=1013&P4192=1013&P4073=1014&P4103=1014&P4133=1014&P4193=1014&P4074=1015&P4104=1015&P4134=1015&P4194=1015&P4075=1016&P4105=1016&P4135=1016&P4195=1016&P4076=1017&P4106=1017&P4136=1017&P4196=1017&P4077=1018&P4107=1018&P4137=1018&P4197=1018&P4078=1019&P4108=1019&P4138=1019&P4198=1019&P4079=1020&P4109=1020&P4139=1020&P4199=1020&P4080=1021&P4110=1021&P4140=1021&P4252=1021&P4081=1022&P4111=1022&P4141=1022&P4253=1022&P4082=1023&P4112=1023&P4142=1023&P4254=1023&P4083=1024&P4113=1024&P4143=1024&P4255=1024&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api.values.post

#Sends reboot to Grandstream to apply the settings
curl --connect-timeout 10 -X POST -d "request=REBOOT&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api-sys_operation
echo ""
echo "GrandStream configuration complete"
echo ""

