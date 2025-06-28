`timescale 1ns/1ps

module receiver_engine (
    input wire clk,
    input wire reset,
    input wire RX,
    output reg [10:0] data_out, // 8 data + 3 error bits (parity, stop, start)
    output reg rx_valid
);
    reg [4:0] bit_count;
    reg [10:0] shift_reg;
    wire calculated_parity; // Khai báo wire bên ngoài

    // Gán giá tr? cho calculated_parity
    assign calculated_parity = ^shift_reg[9:2]; // Parity t? 8 data bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
            rx_valid <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else if (RX == 0 && bit_count == 0) begin // Detect start bit
            bit_count <= 11; // 1 start + 1 parity + 8 data + 1 stop
            rx_valid <= 0;
        end else if (bit_count > 0) begin
            shift_reg <= {RX, shift_reg[10:1]};
            bit_count <= bit_count - 1;
            if (bit_count == 1) begin
                if (shift_reg[0] == 1 && calculated_parity == shift_reg[1]) begin // Stop=1, parity kh?p
                    data_out <= {3'b000, shift_reg[9:2]}; // 8 data bits, no error
                end else begin
                    data_out <= {~{3{shift_reg[0] == 1}}, shift_reg[9:2]}; // ?ánh d?u l?i: ~stop, ~parity_match, ~start
                end
                rx_valid <= 1;
            end
        end
    end
endmodule