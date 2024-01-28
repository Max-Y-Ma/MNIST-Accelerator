`timescale 1ns/1ns

// Core Imports
`include "core_pkg.svh"

// Top Testbench Module for the MNIST Accelerator Core
module top_tb;

// UVM Imports
`include "uvm_macros.svh"
import uvm_pkg::*;

// Clock Generation
bit clk;
always #2 clk = ~clk;

// Global Interface
core_if cif(clk);

// DUT Instantiation
core_wrapper core_wrapper(cif);

// Add Interface to Config Database and Run Tests
initial begin
    uvm_config_db #(virtual core_if)::set(null, "*", "cif", cif);
    run_test();
end

// Dump Wavefiles
initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, "+all");
end

endmodule