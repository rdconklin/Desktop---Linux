#!/bin/bash

##########################################
##                                       #
## GRANDSTREAM Configuration Test Script #
##                                       #
##########################################

: << 'END'
#Gateway Models Supported
GW16=GXW4216
GW24=GXW4224
GW48=GXW4248

echo "Grandstream Configuration"
echo "Please select the gateway model to be configured(1-3):"
echo "1. $GW16"
echo "2. $GW24"
echo "3. $GW48"
read -p INPUT_1


if [$INPUT_1 =1,2,3]
then

	case $INPUT_1 in

		1)
			echo "$GW16"
			;;
		2)
			echo "$GW24"
			;;
		3)
			echo "$GW48"
			;;
	esac

else
	echo "Invalid selection please select from 1-3."
	
fi
END

GATEWAYIP=10.1.20.193
echo "Getting gateway IP"
echo "Grandstream IP: $GATEWAYIP"

echo "Login to Grandstream"

#Generate randsom string for sipsecret
SIPSECRET=$(< /dev/urandom tr -dc A-Za-z0-9_ | head -c16)
echo "SIP Secret: $SIPSECRET"

echo "Getting Session ID"
#Find and parse out the Session ID
#When SID is 12 characters
#OLD --- SID=$(curl --connect-timeout 10 -X POST -d "username=admin&password=changeme" http://$GATEWAYIP/cgi-bin/dologin | grep -o '"sid" : "............' | sed -n -e 's/^.........//p')
#OLD --- SID=$(curl --connect-timeout 10 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | grep -o '"sid" : "............' | sed -n -e 's/^.........//p')
SID=$(curl --connect-timeout 10 -X POST -d "password=admin" http://$GATEWAYIP/cgi-bin/dologin | jq '.body.sid' | tr -d '"')
#echo "SessionID: $SID"

if [ -z "$SID" ]
then
	echo "!!! - Unable to determine Session ID - !!!"
	echo "!!! - Manual configuration required  - !!!"
	echo ""
else

#echo "SID: $SID"

#
#Retrieve and parse Model and Version numbers
#

MODEL=$(curl --connect-timeout 10 -X POST -d "request=P89&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.get | jq '.body.P89' | tr -d '"' | head -c-8)
VERSION=$(curl --connect-timeout 10 -X POST -d "request=P68&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.get | jq '.body.P68' | tr -d '"')

echo "SID: $SID"
echo "Model: $MODEL"
echo "Version: $VERSION"

#Testing for retreiving Gateway Model and Version number
#MODEL_VERSION=$(curl --connect-timeout 10 -X POST -d "request=P89:P68&sid=$SID" http://10.1.20.193:30005/cgi-bin/api.values.get)
#echo "OUTPUT: $MODEL_VERSION"
#echo "MODEL_NUM: $MODEL_NUM"
#echo "VERSION_VER: $MODEL_VER"
#echo "Version: $VERSION"
#page:status_system_info
#Product Model GXW4224 v2.3B 
#Core 1.0.5.11
#SIDi:156d5cc36351
#http://10.1.20.193:30005/#page:status_system_info
#curl --connect-timeout 10 -X POST -d "request=REBOOT&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api-sys_operation

#
#Configurations for the various Models
#
if [ -z "$MODEL" ]
then
	echo "!!! - Unable to determine Model of Gateway - !!!"
	echo "!!! - Manual configuration required        - !!!"
else
case $MODEL in
	GXW4216)
		#
                #Configuration for Original version
                #Once version differences are determined need to layer additional conditions
                #
                #
                #Determine Version #
                #Code
                #
		echo "$MODEL Gateway Model Detected"
		echo "Configuring 16 Analog Ports"
		echo ""
		echo "Grandstream Configuration Completed"
		;;

	GXW4224)
		#
		#Configuration for Original version
		#Once version differences are determined need to layer additional conditions
		#
		#
		#Determine Version #
		#Code
		#Current Version 1.0.5.30
		#
		echo "$MODEL Gateway Model Detected"
		echo "Configuring 24 Analog Ports"
		echo "Set IP"
		echo "..."
		echo "..."
		echo "Result:"
		curl --connect-timeout 10 -X POST -d "P8=1&P9=192&P10=168&P11=3&P12=200&P15=255&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo "..."
		echo "Disable telnet, change admin port, set password"
		echo "..."
		echo "..."
		echo "Result:"
		curl --connect-timeout 10 -X POST -d "P901=30005&P276=1&P2=changeme&:confirmAdminPwd=changeme&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo "..."
		echo "Profile 1 SIP settings set # key behaviour for transfer feature"
		echo "..."
		echo "..."
		echo "Result:"
		curl --connect-timeout 10 -X POST -d "P1406=1&P72=0&P47=192.168.3.100&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo "..."
		echo "FXS settings 1-24"
		echo "..."
		echo "..."
		echo "Result:"
		#Set the dfault value for each SIP channel 1001-1024
		curl --connect-timeout 10 -X POST -d "P4060=1001&P4090=1001&P4120=1001$SIPSECRET&P4180=1001&P4061=1002&P4091=1002&P4121=1002$SIPSECRET&P4181=1002&P4062=1003&P4092=1003&P4122=1003$SIPSECRET&P4182=1003&P4063=1004&P4093=1004&P4123=1004$SIPSECRET&P4183=1004&P4064=1005&P4094=1005&P4124=1005$SIPSECRET&P4184=1005&P4065=1006&P4095=1006&P4125=1006$SIPSECRET&P4185=1006&P4066=1007&P4096=1007&P4126=1007$SIPSECRET&P4186=1007&P4067=1008&P4097=1008&P4127=1008$SIPSECRET&P4187=1008&P4068=1009&P4098=1009&P4128=1009$SIPSECRET&P4188=1009&P4069=1010&P4099=1010&P4129=1010$SIPSECRET&P4189=1010&P4070=1011&P4100=1011&P4130=1011$SIPSECRET&P4190=1011&P4071=1012&P4101=1012&P4131=1012$SIPSECRET&P4191=1012&P4072=1013&P4102=1013&P4132=1013$SIPSECRET&P4192=1013&P4073=1014&P4103=1014&P4133=1014$SIPSECRET&P4193=1014&P4074=1015&P4104=1015&P4134=1015$SIPSECRET&P4194=1015&P4075=1016&P4105=1016&P4135=1016$SIPSECRET&P4195=1016&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api.values.post
		#Sends reboot to Grandstream to apply the settings
		curl --connect-timeout 10 -X POST -d "request=REBOOT&sid=$SID" http://$GATEWAYIP:30005/cgi-bin/api-sys_operation
		echo ""
		echo "GrandStream configuration complete"
		echo ""
                ;;

	GXW4248)
		#
                #Configuration for Original version
                #Once version differences are determined need to layer additional conditions
                #
                #
                #Determine Version #
                #Code
                #Current Version 1.0.5.30
                #
		echo "$MODEL Gateway Model Detected"
		echo "Configuratin 48 Analog Ports"
		echo "Set IP"
		curl --connect-timeout 10 -X POST -d "P8=1&P9=192&P10=168&P11=3&P12=200&P15=255&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo ""
		echo "Disable telnet, change admin port, set password"
		curl --connect-timeout 10 -X POST -d "P901=30005&P276=1&P2=changeme&:confirmAdminPwd=changeme&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo ""
		echo "Profile 1 SIP settings set # key behaviour for transfer feature"
		curl --connect-timeout 10 -X POST -d "P1406=1&P72=0&P47=192.168.3.100&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo ""
		echo "FXS settings 1-16"
		#Set the default valuse for each SIP channel 1001-1016
		curl --connect-timeout 10 -X POST -d "P4060=1001&P4090=1001&P4120=1001$SIPSECRET&P4180=1001&P4061=1002&P4091=1002&P4121=1002$SIPSECRET&P4181=1002&P4062=1003&P4092=1003&P4122=1003$SIPSECRET&P4182=1003&P4063=1004&P4093=1004&P4123=1004$SIPSECRET&P4183=1004&P4064=1005&P4094=1005&P4124=1005$SIPSECRET&P4184=1005&P4065=1006&P4095=1006&P4125=1006$SIPSECRET&P4185=1006&P4066=1007&P4096=1007&P4126=1007$SIPSECRET&P4186=1007&P4067=1008&P4097=1008&P4127=1008$SIPSECRET&P4187=1008&P4068=1009&P4098=1009&P4128=1009$SIPSECRET&P4188=1009&P4069=1010&P4099=1010&P4129=1010$SIPSECRET&P4189=1010&P4070=1011&P4100=1011&P4130=1011$SIPSECRET&P4190=1011&P4071=1012&P4101=1012&P4131=1012$SIPSECRET&P4191=1012&P4072=1013&P4102=1013&P4132=1013$SIPSECRET&P4192=1013&P4073=1014&P4103=1014&P4133=1014$SIPSECRET&P4193=1014&P4074=1015&P4104=1015&P4134=1015$SIPSECRET&P4194=1015&P4075=1016&P4105=1016&P4135=1016$SIPSECRET&P4195=1016&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo ""
		echo "FXS settings 17-32"
		#Set the default valuse for each SIP channel 1017-1032
		curl --connect-timeout 10 -X POST -d "P4076=1017&P4106=1017&P4136=1017$SIPSECRET&P4196=1017&P4077=1018&P4107=1018&P4137=1018$SIPSECRET&P4197=1018&P4078=1019&P4108=1019&P4138=1019$SIPSECRET&P4198=1019&P4079=1020&P4109=1020&P4139=1020$SIPSECRET&P4199=1020&P4080=1021&P4110=1021&P4140=1021$SIPSECRET&P4252=1021&P4081=1022&P4111=1022&P4141=1022$SIPSECRET&P4253=1022&P4082=1023&P4112=1023&P4142=1023$SIPSECRET&P4254=1023&P4083=1024&P4113=1024&P4143=1024$SIPSECRET&P4255=1024&P4084=1025&P4114=1025&P4144=1025$SIPSECRET&P4256=1025&P4085=1026&P4115=1026&P4145=1026$SIPSECRET&P4257=1026&P4086=1027&P4116=1027&P4146=1027$SIPSECRET&P4258=1027&P4087=1028&P4117=1028&P4147=1028$SIPSECRET&P4259=1028&P4088=1029&P4118=1029&P4148=1029$SIPSECRET&P4260=1029&P4089=1030&P4119=1030&P4149=1030$SIPSECRET&P4261=1030&P4240=1031&P4242=1031&P4244=1031$SIPSECRET&P4262=1031&P4241=1032&P4243=1032&P4245=1032$SIPSECRET&P4263=1032&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		echo ""
		echo "FXS settings 33-48"
		#Set the default valuse for each SIP channel 1033-1048
		curl --connect-timeout 10 -X POST -d "P21000=1033&P21064=1033&P21128=1033$SIPSECRET&P21192=1033&P21001=1034&P21065=1034&P21129=1034$SIPSECRET&P21193=1034&P21002=1035&P21066=1035&P21130=1035$SIPSECRET&P21194=1035&P21003=1036&P21067=1036&P21131=1036$SIPSECRET&P21195=1036&P21004=1037&P21068=1037&P21132=1037$SIPSECRET&P21196=1037&P21005=1038&P21069=1038&P21133=1038$SIPSECRET&P21197=1038&P21006=1039&P21070=1039&P21134=1039$SIPSECRET&P21198=1039&P21007=1040&P21071=1040&P21135=1040$SIPSECRET&P21199=1040&P21008=1041&P21072=1041&P21136=1041$SIPSECRET&P21200=1041&P21009=1042&P21073=1042&P21137=1042$SIPSECRET&P21201=1042&P21010=1043&P21074=1043&P21138=1043$SIPSECRET&P21202=1043&P21011=1044&P21075=1044&P21139=1044$SIPSECRET&P21203=1044&P21012=1045&P21076=1045&P21140=1045$SIPSECRET&P21204=1045&P21013=1046&P21077=1046&P21141=1046$SIPSECRET&P21205=1046&P21014=1047&P21078=1047&P21142=1047$SIPSECRET&P21206=1047&P21015=1048&P21079=1048&P21143=1048$SIPSECRET&P21207=1048&sid=$SID" http://$GATEWAYIP/cgi-bin/api.values.post
		#Sends reboot to Grandstream to apply the settings
		curl --connect-timeout 10 -X POST -d "request=REBOOT&sid=$SID" http://$GATEWAYIP/cgi-bin/api-sys_operation
		echo ""
		echo "GrandStream configuration complete"
		echo ""
                ;;
	
esac
echo "Done"
fi
fi
