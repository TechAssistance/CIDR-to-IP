# CIDR-to-IP
Bash script for converting CIDR to IP lists

The main reason for this is there is a nice utility to already do this called prips which can be installed via apt on most systems. The issue is that prips does not allow you to use a list from a file so its kinda dog shit.
Plan is to add stdin support

The origional Script is by @scherand. Cannot find an online ID for direct link. 

# Usage
-h Displays this help screen

-f Forces a check for network boundary when given a STRING(s)

-i Will read from an Input file (file should contain one CIDR per line) (no network boundary check)

-b Will do the same as –i but with network boundary check

# Use case examples:
ASN -> listofCIDR -> listofIPranges. 

./cidr-to-ip.sh 192.168.0.1/24

./cidr-to-ip.sh 192.168.0.1/24 10.10.0.0/28

./cidr-to-ip.sh -f 192.168.0.0/16

./cidr-to-ip.sh -i inputfile.txt

./cidr-to-ip.sh -b inputfile.txt
