#!/bin/bash
# Slacker 2017 - Use and modify at your own risk.
# Script for using LE certificates in a WHM install with Screenconnect. Tested on CentOS7 and WHM 64
# Screenconnect must already be configured to use SSL. 
# Schedule to run 1-2 times per day.

#### CHANGE THE VARIABLES BELOW TO MATCH YOUR INSTALL
SCREENCONNECT_SSL_PORT="8040"
USER=cpanelusername
DOMAIN=domainwithoutextension
EXTENSION=com
####

WORKING_DIRECTORY=$(pwd)
SCREENCONNECT_DIRECTORY=${scdir:-/opt/screenconnect}
HTTPLISTENER_DIRECTORY="$SCREENCONNECT_DIRECTORY/App_Runtime/etc/.mono/httplistener"
CERT_HOME="/home/$USER/ssl"
KEY_NAME=$(grep "Key for “$DOMAIN.$EXTENSION”:" $CERT_HOME/ssl.db | sed "s/      Key for “$DOMAIN.$EXTENSION”: //g").key
BASE=$(echo $KEY_NAME | colrm 13)
CERT_NAME=$(grep "id: ${DOMAIN}_${EXTENSION}_${BASE}" $CERT_HOME/ssl.db | sed 's/      id: //g' ).crt

C1=$(cksum $HTTPLISTENER_DIRECTORY/$SCREENCONNECT_SSL_PORT.cer | colrm 16)
C2=$(cksum  $CERT_HOME/certs/$CERT_NAME | colrm 16)
   if [[ "$C1" != "$C2" ]]
   then    
		openssl rsa -in "$CERT_HOME/keys/$KEY_NAME" -inform PEM -outform PVK -pvk-none -out "$WORKING_DIRECTORY/$SCREENCONNECT_SSL_PORT.pvk"
		[[ ! -d "$HTTPLISTENER_DIRECTORY/backup" ]] && mkdir $HTTPLISTENER_DIRECTORY/backup
		\cp $HTTPLISTENER_DIRECTORY/$SCREENCONNECT_SSL_PORT.* $HTTPLISTENER_DIRECTORY/backup
		\cp $CERT_HOME/certs/$CERT_NAME $HTTPLISTENER_DIRECTORY/$SCREENCONNECT_SSL_PORT.cer
		mv $WORKING_DIRECTORY/$SCREENCONNECT_SSL_PORT.pvk $HTTPLISTENER_DIRECTORY
		service screenconnect restart
   fi
