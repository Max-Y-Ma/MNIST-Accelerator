// Linear Cell Module, Computes Pipelined Multiply/Accumulate Operation
module linear_cell #(
    parameter DATA_WIDTH = 24,
    parameter INPUT_LENGTH = 784,
    parameter WEIGHT_FILE = ""
) (
    input logic clk, rst,
    input logic i_valid,
    input logic [DATA_WIDTH-1:0] din,
    input logic [DATA_WIDTH-1:0] bias,
    output logic [DATA_WIDTH-1:0] dout
);

    // Neuron Controller
    logic accum_rst, accum_load;
    logic [$clog2(INPUT_LENGTH)-1:0] neuron_count;
    always_ff @(posedge clk) begin
        if (rst || (neuron_count == INPUT_LENGTH)) begin
            neuron_count <= '0;
            accum_rst <= 1'b1;
            accum_load <= 1'b0;
        end else if (i_valid || (neuron_count != 0)) begin
            neuron_count <= neuron_count + 1'b1;
            accum_rst <= 1'b0;
            accum_load <= 1'b1;
        end else begin
            neuron_count <= neuron_count;
            accum_rst <= accum_rst;
            accum_load <= accum_load;
        end
    end

    // Delay accumulator control signals
    logic accum_rst_dff, accum_load_dff;
    always_ff @(posedge clk) begin
        accum_rst_dff <= accum_rst;
        accum_load_dff <= accum_load;
    end

    // Weight ROM, 1-Cycle Read Latency
    logic [DATA_WIDTH-1:0] weight;
    weight_rom #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_WEIGHTS(INPUT_LENGTH),
        .WEIGHT_FILE(WEIGHT_FILE)
    ) weight_rom (
        .clk(clk),
        .rst(rst),
        .addr(neuron_count),
        .dout(weight)
    );

    // Delay input to match read latency
    logic [DATA_WIDTH-1:0] din_dff;
    always_ff @(posedge clk) begin
        din_dff <= din;
    end

    // Multiply input sample by weight, adjusted for fixed point
    logic [DATA_WIDTH-1:0] neuron_mult;
    always_ff @(posedge clk) begin
        neuron_mult <= $signed(din_dff) * $signed(weight);
    end

    // Neuron Accumulator
    logic [DATA_WIDTH-1:0] accumulator;
    always_ff @(posedge clk) begin
        if (rst || accum_rst_dff) begin
            accumulator <= '0;
        end else if (accum_load_dff) begin
            accumulator <= $signed(accumulator) + $signed(neuron_mult);
        end else begin
            accumulator <= accumulator;
        end
    end

    // Output Logic
    assign dout = $signed(accumulator) + $signed(bias);

endmodule