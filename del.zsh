del() {
	local trash="$HOME/temp/trash"
	[[ ! -d "$trash" ]] && {
		printf "trash folder not exist\n";
		mkdir -p "$trash";
		return 1;
	}
	(( $# < 1 )) &&  { printf "Include an object to delete\n"; return 1; }
	for arg in $@; do
		if [[ "$1" = -* ]]; then
			case "$1" in
				-show) ls -a --color "$trash" ;;
				-clear) rm -fr "$trash"/* ;;
				*) echo "flag not fount"; return 1 ;;
			esac
			return 0
		fi
		local object="$arg"
		[[ ! -e "$object" ]] && { printf "object $object not found\n"; return 1; }
		mv -i "$object" "$trash"
	done
	return 0
}
