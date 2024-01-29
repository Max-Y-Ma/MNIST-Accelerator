// ReLU Cell Module : ReLU(z) = max(0, z)
module ReLU_cell #(
    parameter DATA_WIDTH = 32
) (
    input logic [DATA_WIDTH-1:0] z,
    output logic [DATA_WIDTH-1:0] ReLU_z
);

    // Check signed bit, assign zero if z is negative
    assign ReLU_z = z[DATA_WIDTH-1] ? '0 : z;
    
endmodule