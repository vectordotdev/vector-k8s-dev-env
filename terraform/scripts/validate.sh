#!/bin/bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

MODULES=(aws)

for MODULE in "${MODULES[@]}"; do
  cd "$MODULE"
  printf "Validating module: %s\n" "$MODULE"
  set -x
  terraform init -backend=false
  terraform validate
  { set +x; } &>/dev/null
  cd ..
done
