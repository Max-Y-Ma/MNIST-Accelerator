// Linear Layer Module, Generate all Linear Cells, Holds Bias Register ROM
module linear_layer #(
    parameter DATA_WIDTH = 24,
    parameter INPUT_LENGTH = 784,
    parameter NUM_NODES = 500,
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

    // Control Logic
    logic [$clog2(INPUT_LENGTH):0] count;
    always_ff @(posedge clk) begin : control_logic
        if (rst || (count == INPUT_LENGTH)) begin
            count <= '0;
        end else if (i_valid || (count != 0)) begin
            count <= count + 1'b1;
        end else begin
            count <= count;
        end
    end

    // Output Valid Logic
    assign o_valid = (count == INPUT_LENGTH);

    // Generate layer of Linear Cells
    generate
        for (genvar i = 0; i < NUM_NODES; i++) begin : Gen_Linear
            linear_cell #(
                .DATA_WIDTH(DATA_WIDTH),
                .WEIGHT_FILE($sformatf("%s%0d.mif", WEIGHT_FILE_PREFIX, i))
            ) linear_cell (
                .clk(clk),
                .rst(rst),
                .i_valid(i_valid),
                .din(din),
                .bias(bias_rom[i]),
                .dout(dout[i])
            );
        end
    endgenerate
    
endmodule