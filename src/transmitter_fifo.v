module transmitter_fifo (
    input wire clk,
    input wire reset,
    input wire wr_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] fifo [0:31];
    reg [4:0] wr_ptr, rd_ptr;
    reg [5:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            empty <= 1;
            data_out <= 0;
        end else if (wr_en && count < 32) begin
            fifo[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
            empty <= (count == 0);
        end else if (count > 0) begin
            data_out <= fifo[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
            empty <= (count == 1);
        end
    end
endmodule