// ReLU Layer Module, Generates all ReLU Cells
module ReLU_layer #(
    parameter DATA_WIDTH = 24,
    parameter NUM_NODES = 20
) (
    input logic [DATA_WIDTH-1:0] zin [NUM_NODES],
    output logic [DATA_WIDTH-1:0] zout [NUM_NODES]
);

    // Generate layer of ReLU Cells
    generate
        for (genvar i = 0; i < NUM_NODES; i++) begin : gen_ReLU
            ReLU_cell #(
                .DATA_WIDTH(DATA_WIDTH)
            ) ReLU_cell (
                .z(zin[i]),
                .ReLU_z(zout[i])
            );
        end
    endgenerate

endmodule