proc() {
    [[ -z $1 ]] || [[ -z $2 ]] && {
		printf "usgae: proc <flag> <process Name>\nFlags:\np:Parent\nmf:Memory footprint\n"
        return 1
    }
	local pid=$(pgrep -o $2)
	[[ -z $pid ]] && { printf "Process not found\n"; return }
	case $1 in
		p)
			local ppid=$(cat /proc/"$pid"/status | grep PPid | awk '{print $2}' )
			if ( cat "/proc/"$ppid"/status" >/dev/null 2>&1 ); then
				local name=$(cat /proc/"$ppid"/status | head -1  | awk '{print $2}' )
				printf "parent:"$name"\nparentId:"$ppid"\n"
			else
				echo "(its ADAM himself)" >&2
			fi
		;;

		mf)
			local returnAllChildren() {
    	   		 local child
#		   		 $# = args
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

    	local pids="$pid $(returnAllChildren "$pid")"

    	[[ -z "$pids" ]] && {
    	    echo "process children lookup error" >&2
    	    return 1
    	}

    	local totalmem=0
    	local cpid psize

    	for cpid in ${=pids}; do
    	    psize=$(awk '/^Pss:/ {print $2}' "/proc/$cpid/smaps_rollup" 2>/dev/null)

    	    [[ -z "$psize" ]] && {
    	        echo "can't read file memory (lack of permission): $cpid" >&2
    	        continue
    	    }

    	    (( totalmem += psize ))
    	done

    	printf "%d MB\n" "$(( totalmem / 1024 ))"
		;;

		*) printf "Flag not known";;
	esac
	return 0
}
