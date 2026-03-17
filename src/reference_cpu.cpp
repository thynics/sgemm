#include "gemm_common.h"

#include <cmath>
#include <cstddef>

namespace sgemm {

void ReferenceGemmCpu(const GemmProblem& problem, const float* a, const float* b,
                      const float* c_in, float* c_out) {
  for (int row = 0; row < problem.m; ++row) {
    for (int col = 0; col < problem.n; ++col) {
      double acc = 0.0;
      for (int kk = 0; kk < problem.k; ++kk) {
        const float a_val = a[row * problem.k + kk];
        const float b_val = b[kk * problem.n + col];
        acc += static_cast<double>(a_val) * static_cast<double>(b_val);
      }
      const int idx = row * problem.n + col;
      c_out[idx] =
          problem.alpha * static_cast<float>(acc) + problem.beta * c_in[idx];
    }
  }
}

ErrorStats ComputeErrorStats(const float* reference, const float* actual, std::size_t count,
                             double rel_epsilon) {
  ErrorStats stats;
  for (std::size_t i = 0; i < count; ++i) {
    const double ref = static_cast<double>(reference[i]);
    const double got = static_cast<double>(actual[i]);
    const double abs_err = std::fabs(got - ref);
    const double denom = std::max(std::fabs(ref), rel_epsilon);
    const double rel_err = abs_err / denom;

    if (abs_err > stats.max_abs_error) {
      stats.max_abs_error = abs_err;
    }
    if (rel_err > stats.max_rel_error) {
      stats.max_rel_error = rel_err;
    }
  }
  return stats;
}

}  // namespace sgemm
