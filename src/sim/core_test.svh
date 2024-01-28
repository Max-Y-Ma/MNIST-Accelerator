// UVM Test Class for MNIST Accelerator Core
class core_test extends uvm_test;
    `uvm_component_utils(core_test)

    // Environment, Sequence
    core_env env;
    core_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Environment
        env = core_env::type_id::create("env", this);
        seq = core_sequence::type_id::create("seq", this);
    endfunction : build_phase

    // Start Sequence
    task run_phase(uvm_phase phase);
        // Run Test Sequence
        phase.raise_objection(this);
        `uvm_info("TEST", "Running MNIST Accelerator Core Test", UVM_MEDIUM);
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask : run_phase
endclass : core_test

// Pipelined Test Class for MNIST Accelerator Core
class core_test_pipeline extends uvm_test;
    `uvm_component_utils(core_test_pipeline)

    // Environment, Sequence
    core_env env;
    core_sequence seq;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Environment
        env = core_env::type_id::create("env", this);
        seq = core_sequence::type_id::create("seq", this);
        // Override Agent Driver
        core_driver::type_id::set_type_override(core_driver_pipeline::get_type());
    endfunction : build_phase

    // Start Sequence
    task run_phase(uvm_phase phase);
        // Run Test Sequence
        phase.raise_objection(this);
        `uvm_info("TEST", "Running MNIST Accelerator Core Test Pipeline", UVM_MEDIUM);
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask : run_phase
endclass : core_test_pipeline