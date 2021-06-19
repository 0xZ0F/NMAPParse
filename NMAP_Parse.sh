# Parse NMAP output.
# Output format example:
#
# Service: HTTP Count: 3
# ==========================
# 192.168.14.8
# 192.168.14.12
# 192.168.14.50
# Service ...

IFS=$'\n'

serviceList=`cat NMAP_all_hosts.txt | egrep '[0-9]+/(tcp|udp)' | awk -F " " '{print $3}' | sort | uniq -c | awk -F " " '{print $2}'` 
ipPattern="([0-9]{1,3}\.){3}[0-9]{1,3}"
outFile="nmapParse/out_"
bool=false
mkdir nmapParse 2>/dev/null
rm -r --preserve-root nmapParse/*

for line in $(cat NMAP_all_hosts.txt)
do
        if [[ $line =~ $ipPattern ]]
        then
                ip=`echo $line | egrep $ipPattern -o`
                echo $ip >> ${outFile}$ip
        elif [[ $line =~ [0-9]+/(tcp|udp) ]]
        then
                echo $line >> ${outFile}$ip
        fi

done

unset $IFS

for svc in $serviceList
do
        ips=`grep -r 'nmapParse/' -iw -e " $svc$" | sort -u -t ":" -k1,1 | cut -d "_" -f2 | cut -d: -f1`
        count=`echo $ips | wc -w`
        echo "Service: $svc Count: $count"
        echo "============================="
        echo $ips | tr " " "\n"
        echo
done
