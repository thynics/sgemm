#include <cstdlib>
#include <iostream>
#include <string>

#include "gemm_common.h"

namespace {

void PrintUsage(const char* argv0) {
  std::cout << "Usage: " << argv0 << " [options]\n"
            << "  --m <int>          Rows of A/C (default 1024)\n"
            << "  --n <int>          Cols of B/C (default 1024)\n"
            << "  --k <int>          Shared dim (default 1024)\n"
            << "  --kernel <name>    naive|simt|wmma|mma_sync|cutlass (default wmma)\n"
            << "  --iters <int>      Timed iterations (default 100)\n"
            << "  --warmup <int>     Warmup iterations (default 20)\n"
            << "  --help             Show this message\n";
}

bool NeedValue(int i, int argc, const std::string& flag) {
  if (i + 1 < argc) {
    return true;
  }
  std::cerr << "Missing value after " << flag << "\n";
  return false;
}

}  // namespace

int main(int argc, char** argv) {
  sgemm::GemmProblem problem;
  sgemm::RunConfig config;

  for (int i = 1; i < argc; ++i) {
    const std::string arg(argv[i]);
    if (arg == "--help" || arg == "-h") {
      PrintUsage(argv[0]);
      return 0;
    }
    if (arg == "--m") {
      if (!NeedValue(i, argc, arg)) return 1;
      problem.m = std::atoi(argv[++i]);
      continue;
    }
    if (arg == "--n") {
      if (!NeedValue(i, argc, arg)) return 1;
      problem.n = std::atoi(argv[++i]);
      continue;
    }
    if (arg == "--k") {
      if (!NeedValue(i, argc, arg)) return 1;
      problem.k = std::atoi(argv[++i]);
      continue;
    }
    if (arg == "--iters") {
      if (!NeedValue(i, argc, arg)) return 1;
      config.iters = std::atoi(argv[++i]);
      continue;
    }
    if (arg == "--warmup") {
      if (!NeedValue(i, argc, arg)) return 1;
      config.warmup_iters = std::atoi(argv[++i]);
      continue;
    }
    if (arg == "--kernel") {
      if (!NeedValue(i, argc, arg)) return 1;
      config.backend = sgemm::ParseBackend(argv[++i]);
      continue;
    }

    std::cerr << "Unknown argument: " << arg << "\n";
    PrintUsage(argv[0]);
    return 1;
  }

  const sgemm::RunResult result = sgemm::RunBenchmark(problem, config);

  std::cout << "[sgemm] backend=" << sgemm::ToString(config.backend) << " M=" << problem.m
            << " N=" << problem.n << " K=" << problem.k << "\n";
  std::cout << "avg_ms=" << result.avg_ms << " tflops=" << result.tflops
            << " max_abs_err=" << result.max_abs_error << " max_rel_err=" << result.max_rel_error
            << " config=" << result.selected_config << "\n";

  return 0;
}
