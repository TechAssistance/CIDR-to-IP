# CIDR-to-IP
Bash script for converting CIDR to IP lists

The main reason for this is there is a nice utility to already do this called prips which can be installed via apt on most systems. The issue is that prips does not allow you to use a list from a file so its kinda dog shit.

Use case example:
ASN -> listofCIDR -> listofIPranges. 

Plan is to add stdin support
