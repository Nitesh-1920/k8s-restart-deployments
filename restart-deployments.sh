#!/usr/bin/env bash
set -uo pipefail

TIMEOUT="300s"  #max wait per Deployment

#format: namespace/deployment
Targets=(
team-a/web-a
team-c/broken
team-b/web-b
)

SUCCESS=()
FAILED=()

for item in "${Targets[@]}";do
  ns="${item%%/*}"                  #everything before the first /
  deployment="${item##*/}"         #everything after the last /

  echo "=== Restarting $deployment in namesapce $ns==="

  if ! kubectl rollout restart deployment "$deployment" -n "$ns"; then
    echo "!! Failed to trigger restart for $ns/$deployment"
    FAILED+=("$item")
    continue
  fi

 # Blocks until the rollout finishes (or timeout hits)
  if kubectl rollout status deployment "$deployment" -n "$ns" --timeout="$TIMEOUT"; then
    echo "OK: $ns/$deployment rolled out"
    SUCCESS+=("$item")
  else
    echo "!! $ns/$deployment did not become ready within $TIMEOUT"
    FAILED+=("$item")
  fi
  echo
done

echo "======== Summary ========"
echo "Succeeded (${#SUCCESS[@]}): ${SUCCESS[*]:-none}"
echo "Failed    (${#FAILED[@]}): ${FAILED[*]:-none}"

[ "${#FAILED[@]}" -eq 0 ] || exit 1
