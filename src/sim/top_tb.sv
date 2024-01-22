module top_tb;

// UVM Imports
import uvm_pkg::*;
`include "uvm_macros.svh"

// Clock Generation
bit clk;
always #2 clk = ~clk;

// Global Interface
core_if cif(clk);

// DUT Instantiation
core_wrapper core_wrapper(cif);

// Add Interface to Config Database and Run Tests
initial begin
    uvm_config_db #(virtual core_if)::set(null, "uvm_test_top", "cif", cif);
    run_test();
end

// Dump Wavefiles
initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, "+all");
end

endmodule