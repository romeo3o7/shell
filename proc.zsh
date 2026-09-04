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

tmu() {
    [[ -z "$1" ]] && {
        echo "provide process id" >&2
        return 1
    }

    local returnAllChildren() {
        local child
#		$# = args
        (( $# == 0 )) && return

        if (( $# == 1 )); then
            child=$(pgrep -P "$1")
        else
	        local loopArgs() {
	            for i in "$@"; do
	                pgrep -P "$i"
	            done
	        }

	        child=$(loopArgs "$@")

        fi

        echo "$child"
        returnAllChildren ${=child}
    }

    local pids="$1 $(returnAllChildren "$1")"

    [[ -z "$pids" ]] && {
        echo "process children lookup error" >&2
        return 1
    }

    local totalmem=0
    local pid psize

    for pid in ${=pids}; do
        psize=$(awk '/^Pss:/ {print $2}' "/proc/$pid/smaps_rollup" 2>/dev/null)

        [[ -z "$psize" ]] && {
            echo "can't read file memory (lack of permission): $pid" >&2
            continue
        }

        (( totalmem += psize ))
    done

    printf "%d MB\n" "$(( totalmem / 1024 ))"
}
