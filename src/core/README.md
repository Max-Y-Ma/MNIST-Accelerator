# About
- This directory contains all `System Verilog` RTL, describing the main accelerator core.
- The top module is located in `core.sv`, the hierarchical module tree is shown below.
- Note: drawings and diagrams can be found in `.../docs/MNIST-Accelerator.pdf`.

# Hierarchical Tree
- `core.sv`
    - `linear_layer.sv`
        - `linear_cell.sv`
            - `weight_rom.sv`
    - `ReLU_layer.sv`
        - `ReLU_cell.sv`

# Design
- The default core features a `784-input` pipelined design.
    - A new 28x28, grayscale input image can be serially feed into the core every 784 clock cycles.
        - After filling the pipeline, the average throughput will be `1 image / 784 clock cycles`.
    - The output of the core is signaled using `o_valid`, having a maximum latency of `1300 clock cycles`.
    - The core can be parameterized upon instantiation, refer to `../src/sim/core_config.svh`.

# Core Interface
 - Continuous Mode
    - In continous mode, reset the core once, then continuously feed pixel data through the serial data input port. The core will output predictions upon the rollover of each image.
 - Single Mode
    - In single mode, reset the core, then feed pixel data through the serial data input port. The core will output its computation once it has recieved the correct amount of input data. Reset the core to initialize a new computation.