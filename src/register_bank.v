module register_bank (
    input wire clk,
    input wire cs,
    input wire wm,
    input wire [3:0] addr,
    input wire [7:0] wdata,
    output reg [10:0] rdata
);
    reg [7:0] reg_file [0:15];

    always @(posedge clk) begin
        if (cs) begin
            if (wm) reg_file[addr] <= wdata;
            else rdata <= {3'b0, reg_file[addr]};
        end
    end
endmodule