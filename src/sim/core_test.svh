// UVM Test Class for MNIST Accelerator Core
import uvm_pkg::*;
`include "uvm_macros.svh"

class core_test extends uvm_test;
    `uvm_component_utils(core_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("TEST", "Running MNIST Accelerator Core Test", UVM_MEDIUM);
        phase.drop_objection(this);
    endtask : run_phase
endclass