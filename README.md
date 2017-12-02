# SC_LE_WHM
Script to use Let's Encrypt certificates in a WHM install with ScreenConnect. Tested on CentOS 7 and WHM 66-68.

You must have your domain setup in cpanel under a regular user and Screenconnect must already be configured to use SSL. 
This script merely checks to see if the LE cert has been modified, converts the key, copies both to SC and restarts the service.

