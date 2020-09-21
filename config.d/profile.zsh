NETWORK_IN=wlan0
NETWORK_IP=$(ip -4 -o addr show ${NETWORK_IN} | awk '{print $4}' | cut -d "/" -f 1 )

echo -e "IP address:\t${NETWORK_IP}"
