#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Usage: $ ./wait-for-db.sh <host> <port> [timeout]

set -eu

host="${1}"
port="${2}"
timeout="${3:-10}"

until PGPASSWORD="${POSTGRES_PASSWORD}" psql \
        --host="${host}" \
        --port="${port}" \
        --username "${POSTGRES_USER}" \
        --dbname "${POSTGRES_DB}" \
        --command '\q' > /dev/null 2>&1; do
  echo "Waiting for postgres to become available..."
  sleep 1
  timeout=$(( timeout-1 ))
  if [ "${timeout}" -eq 0 ]; then
    echo "Bad news! Postgres isn't up :(" >&2
    exit 1
  fi
done

echo "Great news! Postgres is up :)"
