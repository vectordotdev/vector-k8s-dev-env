#!/bin/bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
flux install --version=latest --export gotk-components.yaml
