# CIDR-to-IP
Bash script for converting CIDR to IP lists

The main reason for this is there is a nice utility to already do this called prips which can be installed via apt on most systems. The issue is that prips does not allow you to use a list from a file nor does it allow you to use stdin. You can use NMAP to acomplish this as well but tbh nmap and the long syntax is just overkill to meet this task.

Feel free to request functionality 

# Usage
-h Displays this help screen

-f Forces a check for network boundary when given a STRING(s)

-i Will read from an Input file (file should contain one CIDR per line) (no network boundary check)

-b Will do the same as –i but with network boundary check

# Use case examples:
ASN -> listofCIDR -> listofIPranges. 

cidrip.sh 192.168.0.1/24

cidrip.sh 192.168.0.1/24 10.10.0.0/28

cidrip.sh -f 192.168.0.0/16

cidrip.sh -i inputfile.txt

cidrip.sh -b inputfile.txt

cat listofcidr.txt | cidrip

#### Credits:
Mayberoot

Special thanks to TAO

OG script by @scherand
