dm() {
    if [ -z "$1" ]; then
         echo -e "dm [v/a] {url} {video quality} {save-location} [f/s]\n" >&2
         echo -e "OPTIONS:\nv=video\na=audio\n" >&2
         echo -e "if f; full media download, if s; segment\nsegment structure: h:m:s h:m:s\nfor example: 00:05:20 00:07:00" >&2
        return 1
    fi
    local flag=$1
     if [ "$flag" != "v" ] && [ "$flag" != "a" ]; then
            return 1
     fi

     if [ -z "$2" ]; then
        # echo to stderr
        echo "url is missing" >&2
        return 1
    fi
    local url=$2

    case $1 in
        v)
            if [ -z "$3" ]; then
                echo "video-quality is missing" >&2
                return 1
            fi
            local quality=$3

            if [ -z "$4" ]; then
                echo "location to save is missing" >&2
                return 1
            fi
            local location=$4

            if [ "$quality" != 720 ] && [ "$quality" != 480 ] ; then
                echo "qualities supported = 720 and 480" >&2
                return 1
            fi
                #if not empty
            if [ -n "$5" ]; then
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
            fi

            ~/Programs/yt-dlp/yd -f "(bv*[vcodec=vp9][height<=$quality]/bv*[vcodec=h264][height<=$quality])+ba/b" \
            -P ~/videos/"$location" --js-runtimes "deno:/home/romeo/bin/deno" \
            --replace-in-metadata "title" " " "-" "$url";;

        a)
            if [ -z "$3" ]; then
                echo "location to save is missing" >&2
                return 1
            fi
            local location=$3

            ~/Programs/yt-dlp/yd -x --audio-quality 0 -P ~/music/"$location" --js-runtimes "deno:/home/romeo/bin/deno" --replace-in-metadata "title" " " "-" "$url";;

        *) ;;
    esac
}
