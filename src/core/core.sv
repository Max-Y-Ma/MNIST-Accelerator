/* Interface Description:
 * Continuous Mode: In continous mode, reset the core once, then continuously 
 *                  feed pixel data through the serial data input port. The core
 *                  will output predictions upon the rollover of each image. 
 *
 * Single Mode: In single mode, reset the core, then feed pixel data through
 *              the serial data input port. The core will output its computation
 *              once it has recieved the correct amount of input data. 
 *              Reset the core to initialize a new computation.
 */

// Top Module for the MNIST Accelerator Core
`include "core_config.svh"

module core #(
    parameter DATA_WIDTH = `DATA_WIDTH,
    parameter LAYER1_WIDTH = `LAYER1_WIDTH,
    parameter LAYER2_WIDTH = `LAYER2_WIDTH,
    parameter LAYER3_WIDTH = `LAYER3_WIDTH,
    parameter LAYER4_WIDTH = `LAYER4_WIDTH
) (
    input logic clk, rst,
    input logic i_valid, 
    input logic [DATA_WIDTH-1:0] pixel,
    output logic o_valid,
    output logic [3:0] digit
);

    // Feedforward Linear Layer #1
    logic layer1_o_valid;
    logic [DATA_WIDTH-1:0] layer1_out [LAYER2_WIDTH];
    linear_layer #(
        .DATA_WIDTH(DATA_WIDTH),
        .INPUT_LENGTH(LAYER1_WIDTH),
        .NUM_NODES(LAYER2_WIDTH),
        .BIAS_FILE("layer1_bias.mif"),
        .WEIGHT_FILE_PREFIX("layer1_weights")
    ) linear_layer1 (
        .clk(clk),
        .rst(rst),
        .i_valid(i_valid),
        .din(pixel),
        .dout(layer1_out),
        .o_valid(layer1_o_valid)
    );

    // Feedforward ReLU Layer
    logic layer2_o_valid;
    logic [DATA_WIDTH-1:0] layer2_out [LAYER3_WIDTH];
    ReLU_layer #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_NODES(LAYER3_WIDTH)
    ) ReLU_layer (
        .clk(clk),
        .rst(rst),
        .i_valid(layer1_o_valid),
        .zin(layer1_out),
        .o_valid(layer2_o_valid),
        .zout(layer2_out)
    );

    // Serializer
    logic serializer_o_valid;
    logic [DATA_WIDTH-1:0] layer3_din;
    serializer #(
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_COUNT(LAYER3_WIDTH)
    ) serializer (
        .clk(clk),
        .rst(rst),
        .i_valid(layer2_o_valid),
        .parallel_in(layer2_out),
        .o_valid(serializer_o_valid),
        .serial_out(layer3_din)
    );
    

    // Feedforward Linear Layer #2
    logic layer3_o_valid;
    logic [DATA_WIDTH-1:0] layer3_out [LAYER4_WIDTH];
    linear_layer #(
        .DATA_WIDTH(DATA_WIDTH),
        .INPUT_LENGTH(LAYER3_WIDTH),
        .NUM_NODES(LAYER4_WIDTH),
        .BIAS_FILE("layer2_bias.mif"),
        .WEIGHT_FILE_PREFIX("layer2_weights")
    ) linear_layer2 (
        .clk(clk),
        .rst(rst),
        .i_valid(serializer_o_valid),
        .din(layer3_din),
        .dout(layer3_out),
        .o_valid(layer3_o_valid)
    );

    // Output Logic
    assign o_valid = layer3_o_valid;
    argmax #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_ARGS(LAYER4_WIDTH)
    ) argmax (
        .arg_vector(layer3_out),
        .maxarg(digit)
    );

endmodule