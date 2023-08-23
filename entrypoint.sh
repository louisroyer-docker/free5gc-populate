#!/usr/bin/env bash

set -e
savedargs=( "$@" )
config_opt=0
while [ $# -gt 0 ]; do
	if [[ $1 == "--config" || $1 == "-c" ]]; then
		config_opt=1
	fi
	shift
done
set -- "${savedargs[@]}"

if [[ -n "${CONFIG_TEMPLATE}" && -n "${CONFIG_FILE}" ]]; then
	if [ -n "${TEMPLATE_SCRIPT}" ]; then
		echo "[$(date --iso-8601=s)] Running ${TEMPLATE_SCRIPT}${TEMPLATE_SCRIPT_ARGS:+ }${TEMPLATE_SCRIPT_ARGS} for building ${CONFIG_FILE} from ${CONFIG_TEMPLATE}." > /dev/stderr
		"$TEMPLATE_SCRIPT" "$TEMPLATE_SCRIPT_ARGS"
	fi

	if [[ $config_opt -eq 0 ]]; then
		if [[ -n "${MONGO_HOST}" ]]; then
			exec wait-for-it --timeout=0 --strict --host="${MONGO_HOST}" --port="${MONGO_PORT:-27017}" -- free5gc-populate --config "${CONFIG_FILE}" "$@"
		else
			exec free5gc-populate --config "${CONFIG_FILE}" "$@"
		fi
	else
		if [[ -n "${MONGO_HOST}" ]]; then
			exec wait-for-it --timeout=0 --strict --host="${MONGO_HOST}" --port="${MONGO_PORT:-27017}" -- free5gc-populate "$@"
		else
			exec free5gc-populate "$@"
		fi
	fi
else
	if [[ -n "${MONGO_HOST}" ]]; then
		exec wait-for-it --timeout=0 --strict --host="${MONGO_HOST}" --port="${MONGO_PORT:-27017}" -- free5gc-populate "$@"
	else
		exec free5gc-populate "$@"
	fi
fi
