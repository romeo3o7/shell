gateway(){
	firefox $(netdig g | sed -n 1p | awk '{print $3}')
}
wanip() (
	curl ifconfig.me/all
)

ipinfo() {
	curl ipinfo.io/"$1"
}
