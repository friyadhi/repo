#!/bin/bash
sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
wget http://sourceforge.net/projects/webadmin/files/webmin/1.850/webmin_1.850_all.deb
dpkg -i webmin_1.850_all.deb
