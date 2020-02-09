#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install R3.4 -y
wget https://download2.rstudio.org/server/centos6/x86_64/rstudio-server-rhel-1.2.5033-x86_64.rpm
sudo yum install rstudio-server-rhel-1.2.5033-x86_64.rpm -y
sudo adduser ruser
echo ruser:123456 | sudo chpasswd