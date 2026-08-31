proc() {
	if [ -z "$1" ]; then
		echo "provid process name" >&2
		return 1
	fi
	# process id
	local pid=$(pgrep -oxi "$1")
	if [ -z "$pid" ] || [ "$pid" -eq 0 ]; then
		echo "process is not found" >&2
		return 1
	fi
	printf "process: "$1"\nId:"$pid"\n"

	# Process memory
	if ( cat "/proc/"$pid"/smaps_rollup" >/dev/null 2>&1 ); then
		local rsize=$(echo $((  $(cat /proc/"$pid"/smaps_rollup | sed -n 2p | awk '{print $2}' ) / 1024 )) )
		local psize=$(echo $((  $(cat /proc/"$pid"/smaps_rollup | sed -n 3p | awk '{print $2}' ) / 1024 )) )
		printf "RSS(Process + .so): "$rsize"MB\n"
		printf "PSS(Process + .so/Processes using it): "$psize"MB\n"
	else
		echo "can't read file memory(lack of permission)" >&2
	fi

	# process parent
	local ppid=$(cat /proc/"$pid"/status | grep PPid | awk '{print $2}' )
	if ( cat "/proc/"$ppid"/status" >/dev/null 2>&1 ); then
		local name=$(cat /proc/"$ppid"/status | head -1  | awk '{print $2}' )
		printf "parent:"$name"\nparentId:"$ppid"\n"
	else
		echo "(its ADAM himself)" >&2
	fi
	return 0
}
