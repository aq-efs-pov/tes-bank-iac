#!/usr/bin/env bash
# Pull IaC scan results from the Aqua Supply Chain API.
# Requires: curl, jq, openssl. Env: AQUA_KEY, AQUA_SECRET
set -euo pipefail
: "${AQUA_KEY:?set AQUA_KEY}" "${AQUA_SECRET:?set AQUA_SECRET}"

# Adjust for tenant region (EU: https://eu-1.api.cloudsploit.com / https://eu-1.edge.cloud.aquasec.com)
AUTH_URL="${AQUA_AUTH_URL:-https://api.cloudsploit.com}"
API_URL="${AQUA_API_URL:-https://us-east-1.edge.cloud.aquasec.com}"

# 1) Get a short-lived bearer token (HMAC-signed request)
TS=$(date -u +%s)
TOKEN_PATH="/v2/tokens"
BODY='{"validity":240}'
SIG=$(printf '%s' "${TS}POST${TOKEN_PATH}${BODY}" \
  | openssl dgst -sha256 -hmac "$AQUA_SECRET" -hex | awk '{print $NF}')

TOKEN=$(curl -sS -X POST "${AUTH_URL}${TOKEN_PATH}" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${AQUA_KEY}" \
  -H "X-Timestamp: ${TS}" \
  -H "X-Signature: ${SIG}" \
  -d "$BODY" | jq -r '.data')

[[ -z "$TOKEN" || "$TOKEN" == "null" ]] && { echo "Token request failed" >&2; exit 1; }

# 2) Fetch IaC check results
curl -sS -X GET "${API_URL}/supply_chain/v2/build/checks?check_type=iac" \
  -H "accept: */*" \
  -H "Authorization: Bearer ${TOKEN}" | jq .
