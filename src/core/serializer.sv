module serializer #(
    parameter DATA_WIDTH = 32,
    parameter MAX_COUNT = 20
) (
    input logic clk, rst, i_valid,
    input logic [DATA_WIDTH-1:0] parallel_in [MAX_COUNT],
    output logic o_valid,
    output logic [DATA_WIDTH-1:0] serial_out
);

    // Serialize Parallel Input
    logic [$clog2(MAX_COUNT)-1:0] serializer_count;
    always_ff @(posedge clk) begin
        if (rst || (serializer_count == MAX_COUNT)) begin
            serial_out <= '0;
            serializer_count <= '0;
        end else if (i_valid || (serializer_count != 0)) begin
            serial_out <= parallel_in[serializer_count];
            serializer_count <= serializer_count + 1'b1;
        end else begin
            serial_out <= serial_out;
            serializer_count <= serializer_count;
        end

        o_valid <= i_valid;
    end

endmodule