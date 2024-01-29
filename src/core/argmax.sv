module argmax #(
    parameter DATA_WIDTH = 32,
    parameter NUM_ARGS = 10
) (
    input logic [DATA_WIDTH-1:0] arg_vector [NUM_ARGS],
    output logic [3:0] maxarg
);

    // Argmax Output Logic
    logic [DATA_WIDTH-1:0] max;
    always_comb begin : argmax
        max = '0;
        maxarg = '0;
        for (int i = 0; i < NUM_ARGS; i++) begin
            if ($signed(arg_vector[i]) > $signed(max)) begin
                max = arg_vector[i];
                maxarg = i;
            end
        end
    end

endmodule