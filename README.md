# SC_LE_WHM
Originally coded for using Let's Encrypt/AutoSSL certificates in a WHM install with ScreenConnect, but really it will take whatever cert you have installed for the Screenconnect domain and use it. Tested on CentOS 7.

Screenconnect must already be configured to use SSL. 
This script merely checks to see if the domain's certificate has been modified and, if so, grabs it+the key, copies both to SC and restarts the service.

