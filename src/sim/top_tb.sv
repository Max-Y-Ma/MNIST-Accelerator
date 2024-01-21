class Transaction;
    rand bit [7:0] b;

    covergroup txn_cg;
        coverpoint b;
    endgroup

    function new();
        txn_cg = new();
    endfunction
endclass

module top_tb;

// UVM Imports
import uvm_pkg::*;
`include "uvm_macros.svh"

// DUT Instantiation
logic [23:0] z;
logic [23:0] ReLU_z;
ReLU_Cell relu_cell(
    .z(z),
    .ReLU_z(ReLU_z)
);

initial begin
    Transaction txn;
    txn = new();
    repeat(1000) begin
        txn.randomize();
        txn.txn_cg.sample();
    end
end

// Dump Wavefiles
initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, "+all");
end

endmodule