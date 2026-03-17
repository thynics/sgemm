#pragma once

#include <string>
#include <vector>

#include "gemm_common.h"

namespace sgemm {

struct AutotuneConfig {
  int cta_m = 128;
  int cta_n = 128;
  int cta_k = 32;
  int warp_m = 64;
  int warp_n = 64;
  int warps_per_cta = 4;
  int stages = 2;
  int vector_width = 8;
  bool split_k = false;
  KernelBackend backend = KernelBackend::kWmma;

  std::string Name() const;
};

std::vector<AutotuneConfig> GetDefaultConfigSpace();
AutotuneConfig SelectBestConfig(const std::vector<AutotuneConfig>& candidates,
                                const GemmProblem& problem);

}  // namespace sgemm
