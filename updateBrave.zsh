updateBrave() {
	local dir="$HOME"/Programs/brave
	# meta file should have 
	# Version:v1x.xxx.xx
	if [[ -d "$dir"/update ]] && [[ -f  "$dir"/update/meta ]]; then
		local owner=brave
		local project=brave-browser
		local output=$(curl -fsS "https://api.github.com/repos/$owner/$project/releases/latest")
		[[ -z "$output" ]] && { echo "curling github failed"; return 1; }
		local checkVersion=$(jq -r '.tag_name' <<< "$output")

		[[ "$checkVersion" = "null" ]] || [[ -z "$checkVersion" ]] && { echo "couldn't fetch version for $project"; return 1;}

		local currentVersion=$(grep '^Version' "$dir/update/meta" | sed 's|Version:||')
		[[ "$checkVersion" = "$currentVersion" ]] && { echo "$project is up to date : $checkVersion"; return 0;}

		while true; do
			read -p "$project is on $currentVersion, latest is $checkVersion; do you want to request the latest Version? [y/n]: " response
			case "$response" in
				[Yy])
					echo "Updating.."
					local AssetName=brave-origin-${checkVersion/v}-linux-amd64.zip

				   	local url=$(jq -r --arg name "$AssetName" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$output")

					if [[ -z "$url" ]] || [[ "$url" = "null" ]]; then
					   echo "couldn't find asset matching $AssetName"
				       break
					fi

					if  curl -fL -o "$dir/update/$AssetName" "$url"  ; then
						sed -i "s|Version:.*|Version:$checkVersion|" "$dir"/update/meta
						find "$dir" -mindepth 1 -maxdepth 1 ! -name update -exec rm -rf {} +
						unzip "$dir/update/$AssetName" -d "$dir" >/dev/null
						rm "$dir/update/$AssetName"
					else
						echo "Downloading falied"
						break
					fi

					break;;
				[Nn])
					echo "not Updating"
					break;;
		   		*)
					echo "choose y or n";;
			esac
		done
	fi
}
