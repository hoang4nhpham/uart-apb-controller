module receiver_fifo (
    input wire clk,
    input wire reset,
    input wire wr_en,
    input wire [10:0] data_in, // 8 data + 3 error bits
    output reg [10:0] data_out,
    output reg full
);
    reg [10:0] fifo [0:31];
    reg [4:0] wr_ptr, rd_ptr;
    reg [5:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            data_out <= 0;
        end else if (wr_en && count < 32) begin
            fifo[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
            full <= (count == 31);
        end else if (count > 0) begin
            data_out <= fifo[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
            full <= 0;
        end
    end
endmodule