#!/bin/bash
# Gather Netflix and Amazon AWS IP ranges and put them into single file

set -e
if [ -e getflix.txt ] ; then rm getflix.txt ; fi
# This command finds the ASNUMs owned by netflix
curl -s "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-ASN-CSV&license_key=${LICENSE_KEY}&suffix=zip" >nflix.zip
for as in $(unzip -p nflix.zip `unzip -l nflix.zip |grep -e GeoLite2-ASN-Blocks-IPv4.csv | sed 's/^.\{30\}//g'` | grep -i netflix | cut -d"," -f2 | sort -u)
    do
     whois -h whois.radb.net -- '-i origin AS'$as | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>getflix.tmp
     whois -h whois.radb.net -- '-i origin AS2906' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>getflix.tmp
     whois -h whois.radb.net -- '-i origin AS394406' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>getflix.tmp
     whois -h whois.radb.net -- '-i origin AS40027' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>getflix.tmp
     whois -h whois.radb.net -- '-i origin AS55095' | grep -Eo "([0-9.]+){4}/[0-9]+" | tee netflix_ranges.txt >>getflix.tmp
done

# Netflix only IP address ranges
cat getflix.tmp | aggregate -q >NF_only.txt

# Get the Amazon AWS ip range list
curl -O https://ip-ranges.amazonaws.com/ip-ranges.json
jq -r '[.prefixes | .[].ip_prefix] - [.prefixes[] | select(.service=="GLOBALACCELERATOR").ip_prefix] - [.prefixes[] | select(.service=="AMAZON").ip_prefix] - [.prefixes[] | select(.region=="cn-north-1").ip_prefix] - [.prefixes[] | select(.region=="cn-northwest-1").ip_prefix] | .[]' < ip-ranges.json >> getflix.tmp
jq -r '[.prefixes | .[].ip_prefix] - [.prefixes[] | select(.service=="EC2").ip_prefix] - [.prefixes[] | select(.service=="AMAZON").ip_prefix] - [.prefixes[] | select(.region=="cn-north-1").ip_prefix] - [.prefixes[] | select(.region=="cn-northwest-1").ip_prefix] | .[]' < ip-ranges.json >> getflix.tmp
# unify both the IP address ranges
cat getflix.tmp | aggregate -q >getflix.txt
#tidy the tempfiles
curl -s https://purge.jsdelivr.net/gh/QiuSimons/Netflix_IP/NF_only.txt
curl -s https://purge.jsdelivr.net/gh/QiuSimons/Netflix_IP/getflix.txt
curl -s https://purge.jsdelivr.net/gh/QiuSimons/Netflix_IP@master/getflix.txt
curl -s https://purge.jsdelivr.net/gh/QiuSimons/Netflix_IP@master/NF_only.txt
rm nflix.zip
rm getflix.tmp
rm netflix_ranges.txt
rm ip-ranges.json
