# CIDR-to-IP
Bash script for converting CIDR to IP lists

The main reason for this is there is a nice utility to already do this called prips which can be installed via apt on most systems. The issue is that prips does not allow you to use stdin. Which for my use case is needed. Most tools will use CIDR as input these days but a few older tools do not and well, I like it old school.  

#Use case example:
ASN -> listofCIDR -> listofIPranges. 

