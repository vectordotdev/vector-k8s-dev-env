#!/bin/bash
set -euo pipefail

KUSTOMIZATION_DIR="$1"

# Read the state and print just the resource names.
kubectl get -k "$KUSTOMIZATION_DIR" -o jsonpath='{"{"}"state":[{range .items[*]}"{.apiVersion}|{.kind}|{.metadata.name}"{","}{end}""]{"}"}'
