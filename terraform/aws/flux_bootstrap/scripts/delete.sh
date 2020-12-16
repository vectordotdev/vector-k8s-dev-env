#!/bin/bash
set -euo pipefail

KUSTOMIZATION_DIR="$1"

# Delete the kustomization, ignore failures.
kubectl delete -k "$KUSTOMIZATION_DIR" || true
