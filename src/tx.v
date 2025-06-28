`timescale 1ns/1ps

module transmitter_engine (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg TX,
    output reg tx_done
);
    reg [4:0] bit_count;
    reg [10:0] shift_reg;
    wire parity_bit;

    assign parity_bit = ~^data_in; // Odd parity

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            TX <= 1; // Idle high
            tx_done <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else if (bit_count == 0 && data_in != 0) begin
            shift_reg <= {1'b0, parity_bit, data_in, 1'b1}; // Start=0, parity, 8 data, stop=1
            bit_count <= 11;
            tx_done <= 0;
        end else if (bit_count > 0) begin
            TX <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_count <= bit_count - 1;
            if (bit_count == 1) tx_done <= 1;
        end
    end
endmodule