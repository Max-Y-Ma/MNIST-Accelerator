// Linear Cell Module, Computes Pipelined Multiply/Accumulate Operation
module linear_cell #(
    parameter DATA_WIDTH = 24,
    parameter WEIGHT_FILE = ""
) (
    input logic clk, rst,
    input logic i_valid,
    input logic [DATA_WIDTH-1:0] din,
    input logic [DATA_WIDTH-1:0] bias,
    output logic [DATA_WIDTH-1:0] dout
);



endmodule