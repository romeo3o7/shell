calc() {
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
		echo "missing op" >&2
		return 1
	fi

	local op1="$1"
	local oper="$2"
	local op2="$3"
	case "$oper" in
	"x"|"/"|"+"|"-"|"%")
		[ "$oper" = "x"  ] && oper="*"
		printf "%d\n" "$(($op1 $oper $op2))"
		return 0;;
	*)	echo "Operands:[x,+,-,%,/]" >&2
		return 1;;
	esac
}
