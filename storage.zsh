sdu() {
	local toList
	local location
	local err=false
	if [[ -z $1 ]]; then
		location=$(pwd)
		err=true
	else
		location=$1
	fi
	if [[ -z $2 ]]; then
		toList=-0
		err=true
	else
		toList="$2"
	fi

	[[ ! -e "$location" ]] && {	echo "path not found" >&2; return 1;}

	if [[ $err = true ]] && echo "sdu {path} {how many to list}"

	du -h -d 1 "$location" 2>/dev/null | sort -rh | head -n "$toList"
}
