#include "gemm_common.h"

namespace sgemm {

cudaError_t LaunchMmaSyncGemm(const GemmProblem& problem) {
  (void)problem;
  return cudaSuccess;
}

}  // namespace sgemm
