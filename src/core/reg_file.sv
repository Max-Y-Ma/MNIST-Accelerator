module reg_file #(
    parameter DATA_WIDTH,
    parameter NUM_REGS
) (
    input clk, rst, i_valid,
    input [DATA_WIDTH-1:0] din [NUM_REGS],
    output logic [DATA_WIDTH-1:0] dout [NUM_REGS]
);

    // Register File, Load on i_valid
    logic [DATA_WIDTH-1:0] regfile [NUM_REGS];
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < NUM_REGS; i++) begin : regfile_rst
                regfile[i] <= '0;
            end
        end else if (i_valid) begin
            regfile <= din;
        end else begin
            regfile <= regfile;
        end
    end
    assign dout = regfile;

endmodule