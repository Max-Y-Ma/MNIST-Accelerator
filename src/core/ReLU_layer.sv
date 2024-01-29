// ReLU Layer Module, Generates all ReLU Cells
module ReLU_layer #(
    parameter DATA_WIDTH = 24,
    parameter NUM_NODES = 20
) (
    input logic clk, rst, i_valid,
    input logic [DATA_WIDTH-1:0] zin [NUM_NODES],
    output logic o_valid,
    output logic [DATA_WIDTH-1:0] zout [NUM_NODES]
);

    // Generate layer of ReLU Cells
    logic [DATA_WIDTH-1:0] relu_out [NUM_NODES];
    generate
        for (genvar i = 0; i < NUM_NODES; i++) begin : gen_ReLU
            ReLU_cell #(
                .DATA_WIDTH(DATA_WIDTH)
            ) ReLU_cell (
                .z(zin[i]),
                .ReLU_z(relu_out[i])
            );
        end
    endgenerate

    // Register File
    logic [DATA_WIDTH-1:0] zout_regfile [NUM_NODES];
    reg_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_REGS(NUM_NODES)
    ) reg_file (
        .clk(clk),
        .rst(rst),
        .i_valid(i_valid),
        .din(relu_out),
        .dout(zout_regfile)
    );
    assign zout = zout_regfile;

    // ReLU Valid
    always_ff @(posedge clk) begin : o_valid_dff
        o_valid <= i_valid;
    end

endmodule