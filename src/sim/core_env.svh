// Environment Class for MNIST Accelerator Core
class core_env extends uvm_env;
    `uvm_component_utils(core_env)

    // Agent, Scoreboard, Coverage

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Agent
        // Create Scoreboard
        // Create Coverage
    endfunction : build_phase

    // Connect Ports
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect Agent
    endfunction : connect_phase

endclass : core_env

class core_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(core_scoreboard)

    // Expected and Actual FIFO Ports
    
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Ports
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create FIFO Ports
    endfunction : build_phase

    // Compare Results
    task run_phase(uvm_phase phase);
        // Compare Expected and Actual
    endtask : run_phase

endclass : core_scoreboard

// Coverage
class core_coverage extends uvm_subscriber #(core_img_item);
    `uvm_component_utils(core_coverage)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Create Port
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Analysis Port
    endfunction : build_phase

    // Sample Data
    function void write(core_img_item txn);
        // Sample Data
    endfunction : write

endclass : core_coverage