#include "gemm_common.h"

namespace sgemm {

cudaError_t LaunchCutlassGemm(const GemmProblem& problem) {
  (void)problem;
  return cudaSuccess;
}

}  // namespace sgemm
