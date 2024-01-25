// Top Package for MNIST Accelerator Core
`include "core_config.svh"
`include "core_interface.svh"

package core_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "core_sequence.svh"
    `include "core_agent.svh"
    `include "core_env.svh"
    `include "core_test.svh"
endpackage