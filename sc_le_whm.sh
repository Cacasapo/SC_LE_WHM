#!/bin/bash
# Slacker 2017 - Use and modify at your own risk.
# Script for using LE certificates in a WHM install with Screenconnect.
# Screenconnect must already be configured to use SSL. 
# Schedule to run 1-2 times per day.

#### CHANGE THE VARIABLES BELOW TO MATCH YOUR INSTALL
SCREENCONNECT_SSL_PORT="8040"
DOMAIN=domainname.com
SCREENCONNECT_DIRECTORY="/opt/screenconnect"
####

HTTPLISTENER_DIRECTORY="$SCREENCONNECT_DIRECTORY/App_Runtime/etc/.mono/httplistener"
COMBINED="/var/cpanel/ssl/apache_tls/$DOMAIN/combined"
KEY_NAME="$DOMAIN".key
CERT_NAME="$DOMAIN".cert

mkdir /tmp/sc_le
chmod 700 /tmp/sc_le
cd /tmp/sc_le

csplit -k -f both $COMBINED '/END CERTIFICATE/+1' {1}
csplit -k -f split both00 '/END /+1' {1}
mv split00 $KEY_NAME
mv split01 $CERT_NAME

C1=$(cksum $HTTPLISTENER_DIRECTORY/$SCREENCONNECT_SSL_PORT.cer | colrm 16)
C2=$(cksum  $CERT_NAME | colrm 16)

	if [[ "$C1" != "$C2" ]]
		then
			openssl rsa -in "$KEY_NAME" -inform PEM -outform PVK -pvk-none -out "$SCREENCONNECT_SSL_PORT.pvk"
			[[ ! -d "$HTTPLISTENER_DIRECTORY/backup" ]] && mkdir $HTTPLISTENER_DIRECTORY/backup
			\cp $HTTPLISTENER_DIRECTORY/$SCREENCONNECT_SSL_PORT.* $HTTPLISTENER_DIRECTORY/backup
			\cp $CERT_NAME $HTTPLISTENER_DIRECTORY/$SCREENCONNECT_SSL_PORT.cer
			mv $SCREENCONNECT_SSL_PORT.pvk $HTTPLISTENER_DIRECTORY
			service screenconnect restart
		fi
cd
rm -fr /tmp/sc_le
