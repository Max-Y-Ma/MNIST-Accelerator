// Agent, Sequencer, Driver, Monitor Classes for Test Environment of MNIST Accelerator Core
typedef uvm_sequencer #(core_img_item) core_sequencer;

class core_sequence extends uvm_sequence #(core_img_item);
    `uvm_object_utils(core_sequence)

    // Test Queue
    core_img_item image_queue[$];

    // Constructor
    function new(string name = "");
        super.new(name);
    endfunction : new

    // Enqueue all test images
    virtual function bit load_images();
        // Open Test Data File
        string line;
        int img_file_fd;
        img_file_fd = $fopen(`TEST_DATA_FILE_PATH, "r");
        if (!img_file_fd) begin
            `uvm_fatal("CORE_SEQUENCE", $sformatf("File %s not found", `TEST_DATA_FILE_PATH));
            return 0;
        end

        // Read Test Data File
        while ($fgets(line, img_file_fd)) begin
            // Create Transaction
            core_img_item txn;
            txn = core_img_item::type_id::create("txn");
            // Load Image
            txn.load_image(line);
            // Enqueue Transaction
            image_queue.push_back(txn);
        end
        
        // Close Test Data File
        $fclose(img_file_fd);
        return 1;
    endfunction

    // Sequence Body
    task body;
        // Test Image Number
        int test_image_num = 0;

        // Load Test Dataset
        if (!load_images()) begin
            `uvm_fatal("CORE_SEQUENCE", "Unable to load test dataset! Simulation aborted!");
            return;
        end else begin
            `uvm_info("CORE_SEQUENCE", "Test dataset loaded successfully!", UVM_MEDIUM);
        end

        forever begin
            // Dequeue test image transactions 
            core_img_item txn;
            txn = image_queue.pop_front();
            start_item(txn);
            finish_item(txn);

            // End Sequence
            if (++test_image_num == 1) begin
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

    // Expected FIFO Port
    uvm_put_port #(int) expected_port;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Grab Interface from Configuration Database
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Configuration Database
        if (!uvm_config_db #(virtual core_if)::get(this, "", "cif", cif)) begin
            `uvm_fatal("CORE_DRIVER", "DUT Interface not defined! Simulation aborted!");
        end
        // Create FIFO Port
        expected_port = new("expected_port", this);
    endfunction : build_phase

    // Drive Signal Phase
    task run_phase(uvm_phase phase);
        forever begin
            // Drive Signals
            core_img_item txn;
            seq_item_port.get_next_item(txn);

            // Send Expected Label
            expected_port.put(txn.label);

            // Apply Reset
            @(cif.cb);
            cif.cb.rst <= 1'b0;
            @(cif.cb);
            cif.cb.rst <= 1'b1;
            @(cif.cb);
            cif.cb.rst <= 1'b0;
            
            // Send Pixels Sequentially
            for (int i = 0; i < `IMG_WIDTH * `IMG_HEIGHT; i++) begin
                @(cif.cb);
                cif.cb.i_valid <= 1'b1;
                cif.cb.pixel <= txn.img[i];
            end

            for (int i = 0; i < `IMG_WIDTH * `IMG_HEIGHT; i++) begin
                @(cif.cb);
            end

            for (int i = 0; i < `IMG_WIDTH * `IMG_HEIGHT; i++) begin
                @(cif.cb);
            end

            seq_item_port.item_done();
        end
    endtask : run_phase 
endclass : core_driver

class core_monitor extends uvm_monitor;
    `uvm_component_utils(core_monitor)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // Expected FIFO Port
    uvm_put_port #(int) actual_port;

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
        aport = new("aport", this);
        // Create Interface Port
        if (!uvm_config_db #(virtual core_if)::get(this, "", "cif", cif)) begin
            `uvm_fatal("CORE_MONITOR", "DUT Interface not defined! Simulation aborted!");
        end
        // Create FIFO Port
        actual_port = new("actual_port", this);
    endfunction : build_phase

    // Grab DUT Output Signal
    task run_phase(uvm_phase phase);
        forever begin
            // Grab DUT Output Signal
            core_img_item txn;
            txn = new();
            @(posedge cif.clk iff cif.o_valid);
            txn.label = cif.cb.digit;
            aport.write(txn);
            actual_port.put(txn.label);
        end
    endtask : run_phase

endclass : core_monitor

class core_agent extends uvm_agent;
    `uvm_component_utils(core_agent)

    // Analysis Port
    uvm_analysis_port #(core_img_item) aport;

    // Sequence, Sequencer, Driver, Monitor
    core_sequence seq;
    core_sequencer sequencer;
    core_driver driver;
    core_monitor monitor;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Create Ports and Components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create Analysis Port
        aport = new("aport", this);
        // Create Sequence
        seq = core_sequence::type_id::create("seq", this);
        // Create Sequencer
        sequencer = core_sequencer::type_id::create("sequencer", this);
        // Create Driver
        driver = core_driver::type_id::create("driver", this);
        // Create Monitor
        monitor = core_monitor::type_id::create("monitor", this);
    endfunction : build_phase

    // Connect Ports 
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect Analysis Port w/ Monitor
        monitor.aport.connect(aport);
        // Connect Driver w/ Sequencer
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

    // Run Test Sequence
    task run_phase(uvm_phase phase);
        // Run Test Sequence
        phase.raise_objection(this);
        seq.start(sequencer);
        phase.drop_objection(this);
    endtask

endclass : core_agent