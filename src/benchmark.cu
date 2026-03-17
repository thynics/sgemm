#include <iostream>

#include "gemm_common.h"

namespace sgemm {

namespace {

cudaError_t LaunchByBackend(KernelBackend backend, const GemmProblem& problem) {
  switch (backend) {
    case KernelBackend::kNaive:
    case KernelBackend::kSimt:
      return LaunchSimtGemm(problem);
    case KernelBackend::kWmma:
      return LaunchWmmaGemm(problem);
    case KernelBackend::kMmaSync:
      return LaunchMmaSyncGemm(problem);
    case KernelBackend::kCutlass:
      return LaunchCutlassGemm(problem);
    default:
      return cudaErrorInvalidValue;
  }
}

}  // namespace

RunResult RunBenchmark(const GemmProblem& problem, const RunConfig& config) {
  RunResult result;

  for (int i = 0; i < config.warmup_iters; ++i) {
    const cudaError_t err = LaunchByBackend(config.backend, problem);
    if (err != cudaSuccess) {
      std::cerr << "Warmup launch failed: " << cudaGetErrorString(err) << "\n";
      result.selected_config = "launch_error";
      return result;
    }
  }

  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);
  for (int i = 0; i < config.iters; ++i) {
    const cudaError_t err = LaunchByBackend(config.backend, problem);
    if (err != cudaSuccess) {
      std::cerr << "Timed launch failed: " << cudaGetErrorString(err) << "\n";
      result.selected_config = "launch_error";
      cudaEventDestroy(start);
      cudaEventDestroy(stop);
      return result;
    }
  }
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float elapsed_ms = 0.0f;
  cudaEventElapsedTime(&elapsed_ms, start, stop);
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  result.avg_ms = elapsed_ms / static_cast<double>(config.iters);
  const double flops = 2.0 * static_cast<double>(problem.m) * static_cast<double>(problem.n) *
                       static_cast<double>(problem.k);
  if (result.avg_ms > 0.0) {
    result.tflops = flops / (result.avg_ms * 1e-3) / 1e12;
  }
  result.selected_config = "stub_config";
  return result;
}

}  // namespace sgemm
