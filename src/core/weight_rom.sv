// Read-only Memory Module for Neuron Weights
module weight_rom #(
    parameter DATA_WIDTH = 24,
    parameter NUM_WEIGHTS = 10,
    parameter WEIGHT_FILE = ""
) (
    input logic clk, rst,
    input logic [$clog2(NUM_WEIGHTS)-1:0] addr,
    output logic [DATA_WIDTH-1:0] dout
);

    // Inferable Block RAM or Block ROM
    logic [DATA_WIDTH-1:0] rom [NUM_WEIGHTS];
    initial begin
        $readmemb(WEIGHT_FILE, rom, 0, NUM_WEIGHTS);
    end

    always_ff @(posedge clk) begin : weight_ROM
        if (rst) begin
            dout <= '0;
        end else begin
            dout <= rom[addr];
        end
    end
    
endmodule