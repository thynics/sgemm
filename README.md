# tensorcore-gemm (Makefile Skeleton)

Empty framework for a Tensor Core GEMM project without CMake.

## Build

```bash
make
```

Optional architecture override:

```bash
make CUDA_ARCH=sm80
```

## Run

```bash
make run
# or
./bin/sgemm --m 4096 --n 4096 --k 4096 --kernel wmma --iters 100 --warmup 20
```

## Layout

- `include/`: common structs and autotune config definitions
- `src/`: benchmark driver + kernel/autotune/cutlass placeholders
- `scripts/`: helper scripts for benchmark/profiling/plotting
- `results/`: CSV/NCU/figure outputs
- `docs/`: design and methodology notes

## Status

This is intentionally a scaffold. Kernel bodies and autotune logic are stubs.
