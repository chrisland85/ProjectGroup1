#!/bin/bash
sudo su
yum -y update
yum -y install httpd
#cd /var/www/html
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Hello! My Name is Oluwole Okusolubo and I belong in ACS730 Project Group 1.  My private IP is $myip</h1><br>Built by Terraform!"  >  /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
