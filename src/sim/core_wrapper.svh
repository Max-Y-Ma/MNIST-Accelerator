// Wrapper around MNIST Accelerator Core for Core Interface
`include "core_config.svh"

module core_wrapper(core_if.CORE cif);
    // Core Instantiation
    core #(
        .DATA_WIDTH(`DATA_WIDTH),
        .LAYER1_WIDTH(`LAYER1_WIDTH),
        .LAYER2_WIDTH(`LAYER2_WIDTH),
        .LAYER3_WIDTH(`LAYER3_WIDTH),
        .LAYER4_WIDTH(`LAYER4_WIDTH)
    ) core (
        .clk(cif.clk),
        .rst(cif.rst),
        .i_valid(cif.i_valid),
        .pixel(cif.pixel),
        .o_valid(cif.o_valid),
        .digit(cif.digit)
    );
endmodule