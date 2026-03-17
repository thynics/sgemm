#include "gemm_common.h"

namespace sgemm {

cudaError_t LaunchWmmaGemm(const GemmProblem& problem) {
  (void)problem;
  return cudaSuccess;
}

}  // namespace sgemm
