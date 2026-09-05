updatePrograms() {
	for dir in ~/Programs/*; do
		if [[ -d "$dir"/update ]]; then
			local metadata=$(cat "$dir"/update/meta)
			local owner=$(  echo "$metadata" | grep "Owner"   | sed 's|Owner:||'  )
			local project=$(echo "$metadata" | grep "Project" | sed 's|Project:||')
			local output=$(curl -fsS "https://api.github.com/repos/$owner/$project/releases/latest")
			[[ -z "$output" ]] && { echo "no response for $project"; continue; }
			local checkVersion=$(jq -r '.tag_name' <<< "$output")
			echo "updatable Project : $project"

			[[ "$checkVersion" = "null" ]] || [[ -z "$checkVersion" ]] && { echo "couldn't fetch version for $project"; continue; }

			local currentVersion=$(echo "$metadata" | grep "Version" | sed 's|Version:||')
			[[ "$checkVersion" = "$currentVersion" ]] && { echo "$project is up to date : $checkVersion"; continue; }

			while true; do
				read "response?$project is on $currentVersion, latest is $checkVersion; do you want to request the latest Version? [y/n]: "
				case "$response" in
					[Yy])
						echo "Updating.."
						local name
						if [[ $project = "brave-browser" ]]; then
 							name=$(echo "$metadata" | grep "AssetName" | sed 's|AssetName:||')
						   	name=${name:0:13}${checkVersion/v}${name:13} 
					   	else
 							name=$(echo "$metadata" | grep "AssetName" | sed 's|AssetName:||')
						fi

					   	local url=$(jq -r --arg name "$name" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$output")

 						if [[ -z "$url" ]] || [[ "$url" = "null" ]]; then
						   echo "couldn't find asset matching $name"
						   echo "you may need to change asset name version to $checkVersion"
 					       break
 						fi

						if  curl -fL -o "$dir/update/$name" "$url"  ; then
							sed -i "s|Version:.*|Version:$checkVersion|" "$dir"/update/meta
							[[ $project = "brave-browser" ]] && { 
								find "$dir" -mindepth 1 -maxdepth 1 ! -name update -exec rm -rf {} +
								unzip "$dir/update/$name" -d "$dir" >/dev/null
								rm "$dir/update/$name"
							}
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
	done
}
