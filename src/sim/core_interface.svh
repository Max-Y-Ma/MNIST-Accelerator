// Interface for MNIST Accelerator Core
`include "core_config.svh"

interface core_if(input bit clk);
    // Interface Signals
    logic rst, i_valid;
    logic [`DATA_WIDTH-1:0] pixel;
    logic o_valid;
    logic [3:0] digit;

    // Clocking Block
    clocking cb @(posedge clk);
        input o_valid, digit;
        output rst, i_valid, pixel;
    endclocking

    // Modports
    modport CORE (
        input clk, rst, i_valid, pixel,
        output o_valid, digit
    );

endinterface
