// UVM Test Class for MNIST Accelerator Core
class core_test extends uvm_test;
    `uvm_component_utils(core_test)

    // Environment, Sequence

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Environment
        // Create Sequence
    endfunction : build_phase

    // Start Sequence
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("TEST", "Running MNIST Accelerator Core Test", UVM_MEDIUM);
        phase.drop_objection(this);
    endtask : run_phase
endclass