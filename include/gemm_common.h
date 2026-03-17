#pragma once

#include <algorithm>
#include <cctype>
#include <string>

#include <cuda_runtime.h>

namespace sgemm {

enum class KernelBackend {
  kNaive,
  kSimt,
  kWmma,
  kMmaSync,
  kCutlass,
};

struct GemmProblem {
  int m = 1024;
  int n = 1024;
  int k = 1024;
  float alpha = 1.0f;
  float beta = 0.0f;
};

struct RunConfig {
  KernelBackend backend = KernelBackend::kWmma;
  int warmup_iters = 20;
  int iters = 100;
};

struct RunResult {
  double avg_ms = 0.0;
  double tflops = 0.0;
  double max_abs_error = 0.0;
  double max_rel_error = 0.0;
  std::string selected_config = "stub";
};

inline std::string ToLower(std::string value) {
  std::transform(value.begin(), value.end(), value.begin(), [](unsigned char c) {
    return static_cast<char>(std::tolower(c));
  });
  return value;
}

inline KernelBackend ParseBackend(const std::string& text) {
  const std::string v = ToLower(text);
  if (v == "naive") {
    return KernelBackend::kNaive;
  }
  if (v == "simt") {
    return KernelBackend::kSimt;
  }
  if (v == "mma" || v == "mmasync" || v == "mma_sync") {
    return KernelBackend::kMmaSync;
  }
  if (v == "cutlass") {
    return KernelBackend::kCutlass;
  }
  return KernelBackend::kWmma;
}

inline const char* ToString(KernelBackend backend) {
  switch (backend) {
    case KernelBackend::kNaive:
      return "naive";
    case KernelBackend::kSimt:
      return "simt";
    case KernelBackend::kWmma:
      return "wmma";
    case KernelBackend::kMmaSync:
      return "mma_sync";
    case KernelBackend::kCutlass:
      return "cutlass";
    default:
      return "unknown";
  }
}

RunResult RunBenchmark(const GemmProblem& problem, const RunConfig& config);

cudaError_t LaunchSimtGemm(const GemmProblem& problem);
cudaError_t LaunchWmmaGemm(const GemmProblem& problem);
cudaError_t LaunchMmaSyncGemm(const GemmProblem& problem);
cudaError_t LaunchCutlassGemm(const GemmProblem& problem);

}  // namespace sgemm
