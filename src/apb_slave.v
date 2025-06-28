`timescale 1ns/1ps

module apb_slave (
    input wire pclk,
    input wire presetn,
    input wire pwrite,
    input wire [3:0] paddr,
    input wire [7:0] pwdata,
    output reg [10:0] prdata,
    output reg cs,
    output reg wm,
    output reg [3:0] addr,
    output reg [7:0] wdata
);
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            cs <= 0;
            wm <= 0;
            addr <= 0;
            wdata <= 0;
            prdata <= 0;
        end else begin
            cs <= 1;
            wm <= pwrite;
            addr <= paddr;
            wdata <= pwdata;
            if (!pwrite) prdata <= {3'b0, pwdata};
        end
    end
endmodule