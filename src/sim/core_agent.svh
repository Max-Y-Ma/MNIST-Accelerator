// Agent, Sequencer, Driver, Monitor Classes for Test Environment of MNIST Accelerator Core
class core_agent extends uvm_agent;
    `uvm_component_utils(core_agent)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // Sequencer, Driver, Monitor

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Create Ports and Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Analysis Port
        // Create Sequencer
        // Create Driver
        // Create Monitor
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

typedef uvm_sequencer #(core_img_item) core_sequencer;

class core_sequence extends uvm_sequence #(core_img_item);
    `uvm_object_utils(core_sequence)

    // Constructor
    function new(string name = "");
        super.new(name);
    endfunction : new

    // Sequence Body
    task body;
        forever begin
            // Generate Transactions from Test Dataset
            // core_img_item txn;
            // start_item(txn);
            // finish_item(txn);
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