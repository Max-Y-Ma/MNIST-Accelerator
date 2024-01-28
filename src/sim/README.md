# About
- This directory contains all files needed for `UVM` simulation.
- Refer to `../doc/MNIST-Accelerator.pdf` for testbench architecture.
    - The `UVM` testbench uses a sequence, sequencer, driver style architecture
    - The top-level test module is `top_tb.sv`

# Tests
- Simulation features two tests:
    - Single Mode Test called `core_test`
    - Continuous Mode Test called `core_test_pipeline`

# Usage
- To run the simulation: `make run_sim TEST=<test_name>` from `../src/`
    - Example: `make run_sim TEST=core_test` or `make run_sim TEST=core_test_pipeline`
    - Note all simulation activites current only support `Synonpsys` Toolchain
- To create coverage report: `make covrep` from `../src/`
- To view the waveform report: `make verdi` from `../src/`
