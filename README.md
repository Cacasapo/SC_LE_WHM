# SC_LE_WHM
Script to use Let's Encrypt certificates in a WHM install with ScreenConnect
You must have your domain setup in cpanel under a regular user and Screenconnect must already be configured to use SSL. 
This script merely checks to see if the LE cert has been modified and copies it+key to the Screenconnect install.

WARNING:
This is only lightly tested and has not gone through a Let's Encrypt renew to test. Once that happens, I will remove this warning.

