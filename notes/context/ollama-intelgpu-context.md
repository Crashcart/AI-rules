# Context: Ollama-intelgpu

**Last updated**: 2026-05-30
**Repo**: https://github.com/Crashcart/Ollama-intelgpu

## What This Is

Configuration and tooling for running Ollama (a local LLM runtime) on Intel GPU hardware. GitHub shows C++ as primary language, suggesting low-level GPU binding code rather than just config scripts. Purpose: enable local model inference on Intel GPU (Arc, Iris Xe, or similar) which requires platform-specific SYCL/OpenCL integration that Ollama's standard build does not include.

## Stack

- C++ — primary language (GPU binding layer)
- Likely CMake for build system
- Intel oneAPI / SYCL or OpenCL for GPU acceleration
- Shell scripts for configuration

## Constraints

- **Critical: No C++ Engineer or Embedded Systems Engineer in the approved agent roster.** BACKEND DEVELOPER is the closest available role but lacks GPU programming and systems-level C++ specialization.
- Hardware-specific — tied to Intel GPU hardware; cannot be tested without the physical device
- Intel oneAPI toolchain required for builds
- Last pushed 2026-05-23; 1 open issue

## Open Issues at Onboard

1 open issue as of 2026-05-30.
