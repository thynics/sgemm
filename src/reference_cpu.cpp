#include "gemm_common.h"

namespace sgemm {

void ReferenceGemmCpu(const GemmProblem& problem, const float* a, const float* b,
                      const float* c_in, float* c_out) {
  (void)problem;
  (void)a;
  (void)b;
  (void)c_in;
  (void)c_out;
  // TODO: implement CPU reference GEMM.
}

ErrorStats ComputeErrorStats(const float* reference, const float* actual, std::size_t count,
                             double rel_epsilon) {
  (void)reference;
  (void)actual;
  (void)count;
  (void)rel_epsilon;
  // TODO: implement error-stat computation.
  return ErrorStats{};
}

}  // namespace sgemm
