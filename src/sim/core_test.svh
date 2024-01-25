// UVM Test Class for MNIST Accelerator Core
class core_test extends uvm_test;
    `uvm_component_utils(core_test)

    // Environment, Sequence
    core_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Environment
        env = core_env::type_id::create("env", this);
    endfunction : build_phase

    // Start Sequence
    task run_phase(uvm_phase phase);
        `uvm_info("TEST", "Running MNIST Accelerator Core Test", UVM_MEDIUM);
    endtask : run_phase
endclass