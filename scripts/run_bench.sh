#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${ROOT_DIR}/bin/sgemm"

if [[ ! -x "${BIN}" ]]; then
  echo "Binary not found. Build first with: make"
  exit 1
fi

"${BIN}" --m 4096 --n 4096 --k 4096 --kernel wmma --iters 100 --warmup 20
