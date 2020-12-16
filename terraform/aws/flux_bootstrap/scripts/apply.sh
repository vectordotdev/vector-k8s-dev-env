#!/bin/bash
set -euo pipefail

KUSTOMIZATION_DIR="$1"

# First apply the base installation to enable CRDs.
kubectl apply -f "$KUSTOMIZATION_DIR/gotk-components.yaml"

# Then reapply the whole kustomization.
kubectl apply -k "$KUSTOMIZATION_DIR"
