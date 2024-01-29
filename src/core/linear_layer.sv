// Linear Layer Module, Generate all Linear Cells, Holds Bias Register ROM
module linear_layer #(
    parameter DATA_WIDTH = 24,
    parameter INPUT_LENGTH = 784,
    parameter NUM_NODES = 20,
    parameter BIAS_FILE = "",
    parameter WEIGHT_FILE_PREFIX = ""
) (
    input logic clk, rst,
    input logic i_valid,
    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout [NUM_NODES],
    output logic o_valid
);

    // Bias ROM
    logic [DATA_WIDTH-1:0] bias_rom [NUM_NODES];
    initial begin
        $readmemb(BIAS_FILE, bias_rom, 0, NUM_NODES);
    end

    // Generate layer of Linear Cells
    logic o_valid_vector [NUM_NODES];
    generate
        for (genvar i = 0; i < NUM_NODES; i++) begin : Gen_Linear
            linear_cell #(
                .DATA_WIDTH(DATA_WIDTH),
                .INPUT_LENGTH(INPUT_LENGTH),
                .WEIGHT_FILE($sformatf("%s%0d.mif", WEIGHT_FILE_PREFIX, i))
            ) linear_cell (
                .clk(clk),
                .rst(rst),
                .i_valid(i_valid),
                .din(din),
                .bias(bias_rom[i]),
                .o_valid(o_valid_vector[i]),
                .dout(dout[i])
            );
        end
    endgenerate

    // Output Logic
    assign o_valid = o_valid_vector[0];
    
endmodule