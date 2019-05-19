#!/bin/bash

# Shell Script to create new VirtualHosts
# https://github.com/sjrobert17
# https://twitter.com/sjrobert17
# -------------------------------------------------------------------------
echo "Hello and welcome to my tool for adding VirtualHost to this server"
echo "In order to create a new VirtualHost we must first name it. "
echo "Please type the site name(e.g.) www.example.com or sub.example.com: "
read sitename
DISPLAY="https://$sitename/"
# -------------------------------------------------------------------------
read -e -p "ServerName(www.example.com): " -i "$sitename" ServerName
read -e -p "ServerAlias(example.com): " -i "$sitename" ServerAlias
read -e -p "DocumentFolder: " -i "/var/www/html/$sitename" DocumentFolder
read -e -p "DocumentRoot: " -i "$DocumentFolder/public_html/" DocumentRoot
read -e -p "LogFolder: " -i "$DocumentFolder/logs" LogFolder
read -e -p "ErrorLog: " -i "$LogFolder/error.log" ErrorLog
read -e -p "CustomLog: " -i "$LogFolder/requests.log combined" CustomLog
# -------------------------------------------------------------------------
SitesAvailable="<VirtualHost *:80>
    ServerName $ServerName
    ServerAlias $ServerAlias
    DocumentRoot $DocumentRoot
    ErrorLog $ErrorLog
    CustomLog $CustomLog
</VirtualHost>"
echo "------------------------------"
echo "Virtualhost file: "
echo "------------------------------"
echo "$SitesAvailable"
# -------------------------------------------------------------------------
ConfDir="/etc/httpd/sites-available/"
ConfExt=".conf"
read -e -p "Config Filename: " -i "$ConfDir$sitename$ConfExt" ConfFileName
# -------------------------------------------------------------------------
LinkDir="/etc/httpd/sites-enabled/"
LinkExt=".conf"
read -e -p "Symbolic Link Filename: " -i "$LinkDir$sitename$LinkExt" LinkFileName
# -------------------------------------------------------------------------
read -e -p "Default User Owner: " -i "apache" defaultUser
read -e -p "Default Group Owner: " -i "wheel" defaultGroup
# -------------------------------------------------------------------------
echo "------------------------------"
echo "Will 'touch $ConfFileName'"
echo "Will 'echo \"$SitesAvailable\" >> \"$ConfFileName\"'"
echo "Will 'Mkdir -p $DocumentRoot'"
echo "Will 'Mkdir -p $LogFolder'"
echo "Will 'chown -R $defaultUser:$defaultGroup $DocumentFolder'"
echo "Will 'sudo ln -s $ConfFileName $LinkFileName'"
echo "Will 'service httpd restart'"
echo "------------------------------"
read -p "Would you like to continue with these commands? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n------------------------------\n"
    echo "touch $ConfFileName"
    touch "$ConfFileName"
    echo "echo \"$SitesAvailable\" >> \"$ConfFileName\""
    echo "$SitesAvailable" >> "$ConfFileName"
    echo "Mkdir -p $DocumentRoot"
    mkdir -p "$DocumentRoot"
    echo "Mkdir -p $LogFolder"
    mkdir -p "$LogFolder"
    echo "chown -R $defaultUser:$defaultGroup $DocumentFolder"
    chown -R "$defaultUser":"$defaultGroup" "$DocumentFolder"
    echo "sudo ln -s $ConfFileName $LinkFileName"
    sudo ln -s "$ConfFileName" "$LinkFileName"
    echo "service httpd restart"
    service httpd restart
    echo "-------------DONE-------------"
else
    printf "\n-----------CANCELED-----------\n"    
fi
