#!/bin/bash

if
	test -z "${XDG_CONFIG_HOME}"
then
	XDG_CONFIG_HOME="${HOME}/.config"
fi

CONF_FILE="${XDG_CONFIG_HOME}/chrome-flags.conf"

if
	test -f "${CONF_FILE}"
then
	mapfile -t CONF_LIST < "${CONF_FILE}"
fi

for CONF_LINE in "${CONF_LIST[@]}"
do
	if
		! [[ "${CONF_LINE}" =~ ^[[:space:]]*(#|$) ]]
	then
		FLAG_LIST+=("${CONF_LINE}")
	fi
done

exec /opt/google/chrome/google-chrome "${FLAG_LIST[@]}" "${@}"
