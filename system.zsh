# idle process in the background so the system does not sleep
idle() {
	systemd-inhibit --what=idle sleep infinity
}

# blackhole, sollow stdout/stderr
bh() {
	"$@" >/dev/null 2>&1 &
}
