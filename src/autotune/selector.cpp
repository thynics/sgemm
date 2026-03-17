#include "autotune_space.h"

namespace sgemm {

AutotuneConfig SelectBestConfig(const std::vector<AutotuneConfig>& candidates,
                                const GemmProblem& problem) {
  (void)problem;
  if (candidates.empty()) {
    return AutotuneConfig{};
  }
  return candidates.front();
}

}  // namespace sgemm
