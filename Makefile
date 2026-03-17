NVCC ?= nvcc
CUDA_ARCH ?= sm80
BUILD_DIR ?= build
BIN_DIR ?= bin
TARGET ?= $(BIN_DIR)/sgemm

NVCCFLAGS ?= -std=c++17 -O2 -lineinfo -arch=$(CUDA_ARCH) -Iinclude
HOST_CXXFLAGS ?= -O2

CU_SRCS := $(shell find src -name '*.cu')
CPP_SRCS := $(shell find src -name '*.cpp')
CU_OBJS := $(patsubst src/%.cu,$(BUILD_DIR)/%.o,$(CU_SRCS))
CPP_OBJS := $(patsubst src/%.cpp,$(BUILD_DIR)/%.o,$(CPP_SRCS))
OBJS := $(CU_OBJS) $(CPP_OBJS)

.PHONY: all run clean help

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(dir $@)
	$(NVCC) $(NVCCFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: src/%.cu
	@mkdir -p $(dir $@)
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(NVCC) $(NVCCFLAGS) -Xcompiler "$(HOST_CXXFLAGS)" -c $< -o $@

run: $(TARGET)
	./$(TARGET) --m 1024 --n 1024 --k 1024 --kernel wmma --iters 20 --warmup 5

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

help:
	@echo "Targets:"
	@echo "  make all                Build bin/sgemm"
	@echo "  make run                Run a default benchmark stub"
	@echo "  make clean              Remove build artifacts"
	@echo "Variables:"
	@echo "  CUDA_ARCH=sm80          CUDA architecture (default sm80)"
	@echo "  NVCC=/path/to/nvcc      NVCC executable"
