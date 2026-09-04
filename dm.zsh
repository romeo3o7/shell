dm() {
    [[ -z "$1" ]] && {
         echo -e "dm [v/a] {url} {video quality} {save-location} [f/s]\n" >&2
         echo -e "OPTIONS:\nv=video\na=audio\n" >&2
         echo -e "if f; full media download, if s; segment\nsegment structure: h:m:s h:m:s\nfor example: 00:05:20 00:07:00" >&2
        return 1
	}

    local flag=$1
    [[ "$flag" != "v" ]] && [[ "$flag" != "a" ]] && return 1

    [[ -z "$2" ]] && {echo "url is missing" >&2; return 1 }

	local url=$2

    case $1 in
        v)
            [[ -z "$3" ]] && { echo "video-quality is missing" >&2; return 1}

            local quality=$3

            [[ -z "$4" ]] && { printf "location to save is missing\n" >&2; ls "$HOME/videos"; return 1}

            local location=$4

            [[ "$quality" != 720 ]] && [[ "$quality" != 480 ]] && {echo "qualities supported = 720 and 480" >&2; }

            #if not empty
            [[ -n "$5" ]] && {
                local sflag=$5
                case "$sflag" in

                    f);;
                    s)
                        if [ -z "$6" ]; then
                            echo "first segment not spesified" >&2
                            return 1
                        fi

                        if [ -z "$7" ]; then
                            echo "second segment not spesified" >&2
                            return 1
                        fi
                        local firstSegment=$6
                        local secondSegment=$7
                        ~/Programs/yt-dlp/yd -f "(bv*[vcodec=vp9][height<=$quality]/bv*[vcodec=h264][height<=$quality])+ba/b" \
                                    -P ~/videos/"$location" \
                                    --download-sections "*$firstSegment-$secondSegment"  \
                                    --replace-in-metadata "title" " " "-" "$url"
                        return;;
                    *)
                        echo "f or s please!" >&2
                        return 1;;

                esac
			}

            ~/Programs/yt-dlp/yd -f "(bv*[vcodec=vp9][height<=$quality]/bv*[vcodec=h264][height<=$quality])+ba/b" \
            -P ~/videos/"$location" --js-runtimes "deno:/home/romeo/bin/deno" \
            --replace-in-metadata "title" " " "-" "$url";;

        a)
            [[ -z "$3" ]] && { echo "location to save is missing" >&2; ls "$HOME/music"; return 1}

            local location=$3

            ~/Programs/yt-dlp/yd -x --audio-quality 0 -P ~/music/"$location" --js-runtimes "deno:/home/romeo/bin/deno" --replace-in-metadata "title" " " "-" "$url";;

        *) ;;
    esac
}
