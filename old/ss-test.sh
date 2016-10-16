for server in "us01-22.ssv7.net" "hk02-22.ssv7.net" "sg05-22.ssv7.net" "jp06-22.ssv7.net"
do
    echo "----------$server----------"
    echo `ping -c 3 $server |grep "round-trip"`
done
