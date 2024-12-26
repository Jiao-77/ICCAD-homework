#!/bin/bash

reachable=()
unreachable=()

for host in "$@"; do
	result=$(ping -c 5 -W 1 "$host" 2>/dev/null$)

	if echo "$result" | grep -q "rtt min/avg/max/mdev"; then
		ip=$(echo "$result" | head -1 | awk -F'[()]' '{print $2}')
		avg_time=$(echo "$result" | tail -1 | awk -F'/' '{print $5}')
		reachable+=("$host @ $ip @ $avg_time ms")
	else
		ip=$(nslookup "$host" 2>/dev/null | grep 'Address:' | tail -n 1 | awk '{print $2}')
		[[ -z "$ip" ]] && ip="UNKNOWN"
		unreachable+=("$host @ $ip is unreachable")
	fi
done

reachable_sorted=$(printf "%s\n" "${reachable[@]}" | sort -t '@' -k3 -n)
ubreachable_sorted=$(printf "%s\n" "${unreachable[@]}" |sort -t '@' -k2)

echo "$reachable_sorted"
echo "$ubreachable_sorted"
