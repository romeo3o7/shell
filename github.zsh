update() {
	for dir in ~/Programs/*; do
		if [ -d "$dir"/update ]; then
			echo "updatable folder found in $dir"
			local metadata=$(cat "$dir"/update/meta)
			local owner=$(  echo "$metadata" | grep "Owner"   | sed 's|Owner:||'  )
			local project=$(echo "$metadata" | grep "Project" | sed 's|Project:||')
			local checkVersion=$(curl -s https://api.github.com/repos/"$owner"/"$project"/releases/latest | jq -r '.tag_name')
			if [ "$checkVersion" = "null" ] || [ -z "$checkVersion" ]; then
   				 echo "couldn't fetch version for $project"
   				 continue
			fi
			printf "$project : $checkVersion\n"
			while true; do
				read "response?Do you wish to install the newest release from $project? [y/n]: "
				case "$response" in
					[Yy])
						echo "Upating"
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
