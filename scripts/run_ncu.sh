#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${ROOT_DIR}/bin/sgemm"
OUT_DIR="${ROOT_DIR}/results/ncu"

mkdir -p "${OUT_DIR}"

if [[ ! -x "${BIN}" ]]; then
  echo "Binary not found. Build first with: make"
  exit 1
fi

ncu --set full --target-processes all -o "${OUT_DIR}/wmma_4096" \
  "${BIN}" --m 4096 --n 4096 --k 4096 --kernel wmma --iters 50 --warmup 10
