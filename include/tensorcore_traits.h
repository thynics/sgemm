#pragma once

namespace sgemm {

struct TensorCoreTraits {
  int warp_m = 16;
  int warp_n = 16;
  int warp_k = 16;
  int cta_m = 128;
  int cta_n = 128;
  int cta_k = 32;
};

}  // namespace sgemm
