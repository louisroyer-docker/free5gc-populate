#!/usr/bin/env bash
set -e
if [ -z "$MONGO_HOST" ]; then
	echo "Missing mandatory environment variable (MONGO_HOST)." > /dev/stderr
	exit 1
fi
if [ -z "$SLICES" ]; then
	echo "Missing mandatory environment variable (SLICES)." > /dev/stderr
	exit 1
fi
if [ -z "$IMSI" ]; then
	echo "Missing mandatory environment variable (IMSI)." > /dev/stderr
	exit 1
fi

sed \
	-e "s/%MONGO_HOST/${MONGO_HOST}/g" \
	-e "s/%MONGO_PORT/${MONGO_PORT:-27017}/g" \
	-e "s/%MONGO_NAME/${MONGO_NAME:-free5gc}/g" \
	-e "s/%MCC/${MCC:-001}/g" \
	-e "s/%MNC/${MNC:-01}/g" \
	-e "s/%KEY/${KEY:-8baf473f2f8fd09487cccbd7097c6862}/g" \
	-e "s/%OP/${OP:-8e27b6af0e692e750f32667a3b14605d}/g" \
	-e "s/%SQN/${SQN:-16f3b3f70fc2}/g" \
	-e "s/%AMF/${AMF:-8000}/g" \
	-e "s/%SLICES/${SLICES}/g" \
	-e "s/%IMSI/${IMSI}/g" \
"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
