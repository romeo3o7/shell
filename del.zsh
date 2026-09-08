del() {
	(( $# < 1 )) &&  { printf "Include an object to delete\n"; return 1; }
	local trash="$HOME/temp/trash"
	if [[ "$1" = -* ]]; then
		case "$1" in
			-show) ls "$trash" ;;
			-clear) rm -fr "$trash"/* ;;
			*) echo "flag not fount"; return 1 ;;
		esac
		return 0
	fi
	local object="$1"
	[[ ! -d "$trash" ]] && { printf "trash folder not exist\n"; return 1; }
	[[ ! -e "$object" ]] && { printf "object not found\n"; return 1; }
	mv -i "$object" "$trash"
	return 0
}
