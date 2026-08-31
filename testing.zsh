battery() {
    local highNotifed=false
    local lowNotifed=false

    check() {
        local battery
        battery=$(cat /sys/class/power_supply/BAT1/capacity)
        if [ "$battery" -ge 85 ] && [ "$highNotifed" = false ]; then
            notify-send -t 10000 "battery too high"
            highNotifed=true
        fi
        if [ "$battery" -le 26 ] && [ "$lowNotifed" = false ]; then
            notify-send -t 10000 "battery too low"
            lowNotifed=true
        fi
        [ "$battery" -le 84 ] && highNotifed=false
        [ "$battery" -ge 27 ] && lowNotifed=false
    }

    check

    trap 'pkill -f "busctl wait.*battery_BAT1"; pkill -f "grep --line-buffered -i percentage"' EXIT INT

    while read -r line; do
        check
    done < <(busctl wait --limit-messages=1000000 -j org.freedesktop.UPower \
		/org/freedesktop/UPower/devices/battery_BAT1 org.freedesktop.DBus.Properties PropertiesChanged | grep --line-buffered -i "percentage")
}
movess() {
for file in ~/dotfiles/zsh/zsh-functions/*; do
	local dirName=$(dirname $file)
	local fileName=$(echo "$file" | sed "s|$dirName/||")
	ln ~/dotfiles/zsh/zsh-functions/"$fileName" ~/projects/shell/"$fileName"
	# hi i was here
done
}
