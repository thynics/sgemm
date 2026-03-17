#include "autotune_space.h"

namespace sgemm {

std::string AutotuneConfig::Name() const {
  return "cta(" + std::to_string(cta_m) + "x" + std::to_string(cta_n) + "x" +
         std::to_string(cta_k) + ")_warp(" + std::to_string(warp_m) + "x" +
         std::to_string(warp_n) + ")_w" + std::to_string(warps_per_cta) + "_s" +
         std::to_string(stages) + (split_k ? "_splitk" : "");
}

std::vector<AutotuneConfig> GetDefaultConfigSpace() {
  return {
      {128, 128, 32, 64, 64, 4, 2, 8, false, KernelBackend::kWmma},
      {128, 256, 32, 64, 64, 8, 2, 8, false, KernelBackend::kWmma},
      {64, 128, 32, 64, 32, 4, 2, 8, false, KernelBackend::kWmma},
  };
}

}  // namespace sgemm
