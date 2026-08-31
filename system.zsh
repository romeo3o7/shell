# idle process in the background so the system does not sleep
idle() {
	systemd-inhibit --what=idle sleep infinity
}

# blackhole, sollow stdout/stderr
bh() {
	"$@" >/dev/null 2>&1 &
}

#mk dir and cd
mkdircd() {
	[ -z "$1" ] && return 1
	mkdir "$1"
	cd "$1"
}
