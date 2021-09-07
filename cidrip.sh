#!/bin/bash    

prefix_to_bit_netmask() {
    prefix=$1;
    shift=$(( 32 - prefix ));

    bitmask=""
    for (( i=0; i < 32; i++ )); do
        num=0
        if [ $i -lt $prefix ]; then
            num=1
        fi

        space=
        if [ $(( i % 8 )) -eq 0 ]; then
            space=" ";
        fi

        bitmask="${bitmask}${space}${num}"
    done
    echo $bitmask
}

bit_netmask_to_wildcard_netmask() {
    bitmask=$1;
    wildcard_mask=
    for octet in $bitmask; do
        wildcard_mask="${wildcard_mask} $(( 255 - 2#$octet ))"
    done
    echo $wildcard_mask;
}

check_net_boundary() {
    net=$1;
    wildcard_mask=$2;
    is_correct=1;
    for (( i = 1; i <= 4; i++ )); do
        net_octet=$(echo $net | cut -d '.' -f $i)
        mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
        if [ $mask_octet -gt 0 ]; then
            if [ $(( $net_octet&$mask_octet )) -ne 0 ]; then
                is_correct=0;
            fi
        fi
    done
    echo $is_correct;
}

OPTIND=1;
getopts "fibh" force;

shift $((OPTIND-1))
if [ $force = 'h' ]; then
    echo ""
    echo "THIS SCRIPT WILL EXPAND A CIDR ADDRESS." 
    echo "cidrip [OPTION(only one)] [STRING/FILENAME]"
    echo ""
    echo "OPTIONS:"
    echo "-h  Displays this help screen"
    echo "-f  Forces a check for network boundary when given a STRING(s)"    
    echo "-i  Will read from an Input file (no network boundary check)"
    echo "-b  Will do the same as –i but with network boundary check"
    echo ""
    exit
fi

if [ -p /dev/stdin ]; then
        echo "Data was piped to this script!"
        old_IPS=$IFS
	while IFS= read line; do
		lines+=(${line})
		echo ${line}
	done
	IFS=$old_IPS
	else
		lines=$@
fi


if [ $force = 'i' ] || [ $force = 'b' ]; then

    old_IPS=$IPS
    IPS=$'\n'
    lines=($(cat $1)) # array
    IPS=$old_IPS
        else
            lines=$@
fi

for ip in ${lines[@]}; do
    net=$(echo $ip | cut -d '/' -f 1);
    prefix=$(echo $ip | cut -d '/' -f 2);
    do_processing=1;

    bit_netmask=$(prefix_to_bit_netmask $prefix);

    wildcard_mask=$(bit_netmask_to_wildcard_netmask "$bit_netmask");
    is_net_boundary=$(check_net_boundary $net "$wildcard_mask");

    if [ $force = 'f' ] && [ $is_net_boundary -ne 1 ] || [ $force = 'b' ] && [ $is_net_boundary -ne 1 ] ; then
        read -p "Not a network boundary! Continue anyway (y/N)? " -n 1 -r
        echo    ## move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            do_processing=1;
        else
            do_processing=0;
        fi
    fi  

    if [ $do_processing -eq 1 ]; then
        str=
        for (( i = 1; i <= 4; i++ )); do
            range=$(echo $net | cut -d '.' -f $i)
            mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
            if [ $mask_octet -gt 0 ]; then
                range="{$range..$(( $range | $mask_octet ))}";
            fi
            str="${str} $range"
        done
        ips=$(echo $str | sed "s, ,\\.,g"); ## replace spaces with periods, a join...

        eval echo $ips | tr ' ' '\n'
else
exit
    fi

done
