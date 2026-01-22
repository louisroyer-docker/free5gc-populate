#!/usr/bin/env bash
# Copyright Louis Royer. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

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

IFS=$'\n'
SLICES_SUB=""
for SLICE in ${SLICES}; do
	if [ -n "${SLICE}" ]; then
		SLICES_SUB="${SLICES_SUB}\n  ${SLICE}"
	fi
done

IMSI_SUB=""
for I_IMSI in ${IMSI}; do
	if [ -n "${I_IMSI}" ]; then
		IMSI_SUB="${IMSI_SUB}\n  ${I_IMSI}"
	fi
done

awk \
	-v MONGO_HOST="${MONGO_HOST}" \
	-v MONGO_PORT="${MONGO_PORT:-27017}" \
	-v MONGO_NAME="${MONGO_NAME:-free5gc}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v KEY="${KEY:-8baf473f2f8fd09487cccbd7097c6862}" \
	-v OP="${OP:-8e27b6af0e692e750f32667a3b14605d}" \
	-v SQN="${SQN:-16f3b3f70fc2}" \
	-v AMF="${AMF:-8000}" \
	-v SLICES="${SLICES_SUB}" \
	-v IMSI="${IMSI_SUB}" \
	'{
		sub(/%MONGO_HOST/, MONGO_HOST);
		sub(/%MONGO_PORT/, MONGO_PORT);
		sub(/%MONGO_NAME/, MONGO_NAME);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%KEY/, KEY);
		sub(/%OP/, OP);
		sub(/%SQN/, SQN);
		sub(/%AMF/, AMF);
		sub(/%SLICES/, SLICES);
		sub(/%IMSI/, IMSI);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
