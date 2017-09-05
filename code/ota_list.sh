#!/bin/bash

exists() {
    command -v "$1" >/dev/null 2>&1
}

echo_pad() {
    string=$1
    pad=$2
    printf '%s' "$string"
    printf '%*s' $(( $pad - ${#string} ))
}

useAvahi() {

    echo_pad "#" 4
    echo_pad "HOSTNAME" 20
    echo_pad "IP" 20
    echo_pad "DEVICE" 30
    echo_pad "VERSION" 10
    echo

    printf -v line '%*s\n' 84
    echo ${line// /-}

    counter=0

    avahi-browse -t -r -p  "_arduino._tcp" 2>/dev/null | grep ^= | while read line; do

        (( counter++ ))

        hostname=`echo $line | cut -d ';' -f4`
        ip=`echo $line | cut -d ';' -f8`
        txt=`echo $line | cut -d ';' -f10`
        board=`echo $txt | sed -n "s/.*espurna_board=\([^\"]*\).*/\1/p"`
        version=`echo $txt | sed -n "s/.*espurna_version=\([^\"]*\).*/\1/p"`

        echo_pad "$counter" 4
        echo_pad "$hostname" 20
        echo_pad "$ip" 20
        echo_pad "$board" 30
        echo_pad "$version" 10
        echo

    done

    echo

}

# ------------------------------------------------------------------------------

# Welcome
echo
echo "--------------------------------------------------------------"
echo "OTA-UPDATABLE DEVICES"
echo "--------------------------------------------------------------"
echo

if exists avahi-browse; then
    useAvahi
else
    echo "Avahi not installed"
    exit 1
fi