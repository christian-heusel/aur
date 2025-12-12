#!/bin/bash

if
	test -z "${XDG_CONFIG_HOME}"
then
	XDG_CONFIG_HOME="${HOME}/.config"
fi

CONFIG_FILE="${XDG_CONFIG_HOME}/chrome-beta-flags.conf"

if
	test -f "${CONFIG_FILE}"
then
	mapfile -t -- CONFIG_LIST < "${CONFIG_FILE}"
fi

for CONFIG_LINE in "${CONFIG_LIST[@]}"
do
	if
		! [[ "${CONFIG_LINE}" =~ ^[[:space:]]*('#'|$) ]]
	then
		OPTION_LIST+=("${CONFIG_LINE}")
	fi
done

exec /opt/google/chrome-beta/google-chrome-beta "${OPTION_LIST[@]}" "${@}"
