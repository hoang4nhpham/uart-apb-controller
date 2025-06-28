`timescale 1ns/1ps

module baud_rate_generator (
    input wire clk,
    input wire reset,
    output reg baud_clk
);
    parameter DIVIDER = 5208; // 50MHz / 5208 ? 9600 baud
    reg [15:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            baud_clk <= 0;
        end else if (counter == DIVIDER - 1) begin
            counter <= 0;
            baud_clk <= ~baud_clk;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule