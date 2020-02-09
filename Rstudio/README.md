# Install R Studio
Install R Studio on a remote linux instance on AWS. Access the linux instance via browse
## Create VPC with Route table
Create VPC
Create VPC with 10.0.0.0/16 IPv4 CIDR

## Create IGW
Create the Internet Gateway and associate it with the VPC created in the previous step.

## Create subnet
The route table should have two entries 
10.0.0.0/16 Target local
0.0.0.0/0 Target IGW

## Create instance 
Create Amazon linux instance, free tier. 
Copy contents from aws-userdata.sh file into the user data section
Create new security group for incoming traffic to 22 and 8787
Create and download new pem key
Launch instance

## Log into instance via ssh
Not required

## Access R-studio via browser
http://<public-ip-address>:8787
User credentials to log into server