#!/bin/bash

# Substitute XDG_CONFIG_HOME by ~/.config if the env var is unset or empty
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# Allow users to override command-line options
if [[ -f "${XDG_CONFIG_HOME}/spotify-flags.conf" ]]; then
    mapfile -t SPOTIFY_USER_FLAGS <<< "$(grep -v '^#' "${XDG_CONFIG_HOME}/spotify-flags.conf")"
    echo "User flags:" "${SPOTIFY_USER_FLAGS[@]}"
fi

# Spotify supports opening in existing instance but it needs a specific format
convert_uri() {
    local output_uri="${1/:\/\//:}"
    local output_uri="${output_uri/\//:}"
    local output_uri=$(echo "$output_uri" | sed 's/\?.*si=/\:/')
    echo "$output_uri"
}

execute='/opt/spotify/spotify "${SPOTIFY_USER_FLAGS[@]}"'
if [[ "$1" == spotify:* ]]; then
    eval $execute --uri=$(convert_uri "$1")
else
    eval $execute
fi
