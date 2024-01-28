// Environment Class for MNIST Accelerator Core
class core_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(core_scoreboard)

    // Actual FIFO Ports
    uvm_get_port #(int) actual_port;
    uvm_get_port #(int) expected_port;

    // Score
    int num_correct;
    int num_total;
    
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Ports
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create FIFO Ports
        actual_port = new("actual_port", this);
        expected_port = new("expected_port", this);
    endfunction : build_phase

    // Sample Data
    task run_phase(uvm_phase phase);
        forever begin
            // Sample Data
            int actual_label, expected_label;
            expected_port.get(expected_label);
            actual_port.get(actual_label);

            // Compare and Record Accuracy
            num_total++;
            if (actual_label == expected_label) begin
                num_correct++;
            end

            // Report Results
            `uvm_info("SCOREBOARD", $sformatf("\nExpected:%0d | Actual:%0d", expected_label, actual_label), UVM_LOW);
            `uvm_info("SCOREBOARD", $sformatf("\nAccuracy: %0d/%0d (%0.2f%%)", num_correct, num_total, 100.0 * num_correct / num_total), UVM_LOW);
        end
    endtask : run_phase

endclass : core_scoreboard

// Coverage
class core_coverage extends uvm_subscriber #(core_img_item);
    `uvm_component_utils(core_coverage)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // Covergroup
    covergroup core_img_cg with function sample(int label);
        coverpoint label { bins l_range[] = {[0:9]}; }
    endgroup : core_img_cg

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        core_img_cg = new;
    endfunction : new

    // Create Port
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Analysis Port
        aport = new("aport", this);
    endfunction : build_phase

    // Sample Data
    function void write(core_img_item txn);
        // Sample Data
        core_img_cg.sample(txn.label);
    endfunction : write

endclass : core_coverage

class core_env extends uvm_env;
    `uvm_component_utils(core_env)

    // Agent, Scoreboard, Coverage
    core_agent agent;
    core_scoreboard scoreboard;
    core_coverage coverage;

    // Expected and Actual FIFO
    uvm_tlm_fifo #(int) expected_fifo;
    uvm_tlm_fifo #(int) actual_fifo;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Agent
        agent = core_agent::type_id::create("agent", this);
        // Create Scoreboard
        scoreboard = core_scoreboard::type_id::create("scoreboard", this);
        // Create Coverage
        coverage = core_coverage::type_id::create("coverage", this);
        // Create UVM FIFO
        expected_fifo = new("expected_fifo", this);
        actual_fifo = new("actual_fifo", this);
    endfunction : build_phase

    // Connect Ports
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect Scoreboard and Coverage Analysis Ports
        agent.aport.connect(coverage.analysis_export);
        // Connect Expected and Actual FIFO      
        agent.driver.expected_port.connect(expected_fifo.put_export);
        scoreboard.expected_port.connect(expected_fifo.get_export); 
        agent.monitor.actual_port.connect(actual_fifo.put_export);
        scoreboard.actual_port.connect(actual_fifo.get_export);
    endfunction : connect_phase
endclass : core_env