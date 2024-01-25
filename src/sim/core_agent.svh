// Agent, Sequencer, Driver, Monitor Classes for Test Environment of MNIST Accelerator Core
typedef uvm_sequencer #(core_img_item) core_sequencer;

class core_sequence extends uvm_sequence #(core_img_item);
    `uvm_object_utils(core_sequence)

    // Constructor
    function new(string name = "");
        super.new(name);
    endfunction : new

    // Sequence Body
    task body;
        int test_image_num = 0;
        forever begin
            // Generate Transactions from Test Dataset
            core_img_item txn;
            txn = core_img_item::type_id::create("txn");
            // start_item(txn);
            txn.load_image(`TEST_DATA_FILE_PATH, test_image_num++);
            // finish_item(txn);

            // End Sequence
            if (test_image_num == `TEST_SAMPLES) begin
                `uvm_info("CORE_SEQUENCE", "Test Sequence Completed", UVM_MEDIUM);
                break;
            end
        end
    endtask : body
endclass : core_sequence

class core_driver extends uvm_driver #(core_img_item);
    `uvm_component_utils(core_driver)

    // DUT Interface
    virtual core_if cif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Grab Interface from Configuration Database
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual core_if)::get(this, "", "cif", cif))
            `uvm_fatal("CORE_DRIVER", "DUT Interface not defined! Simulation aborted!");
    endfunction : build_phase

    // Drive Signal Phase
    task run_phase(uvm_phase phase);
        forever begin
            // Drive Signals
        end
    endtask : run_phase 

endclass : core_driver

class core_monitor extends uvm_monitor;
    `uvm_component_utils(core_monitor)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // DUT Interface
    virtual core_if cif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Create Ports
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Analysis Port
        // Create Interface Port
    endfunction : build_phase

    // Grab DUT Output Signal
    task run_phase(uvm_phase phase);
        forever begin
            // Grab DUT Output Signal
        end
    endtask : run_phase

endclass : core_monitor

class core_agent extends uvm_agent;
    `uvm_component_utils(core_agent)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // Sequencer, Driver, Monitor
    core_sequencer sequencer;
    // core_driver driver;
    // core_monitor monitor;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Create Ports and Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Analysis Port
        // Create Sequencer
        sequencer = core_sequencer::type_id::create("sequencer", this);
        // Create Driver
        // driver = core_driver::type_id::create("driver", this);
        // Create Monitor
        // monitor = core_monitor::type_id::create("monitor", this);
    endfunction : build_phase

    // Connect Ports 
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect Analysis Port
        // Connect Sequencer
        // Connect Driver
        // Connect Monitor
    endfunction : connect_phase

endclass : core_agent