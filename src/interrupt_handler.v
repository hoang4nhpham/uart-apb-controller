module interrupt_handler (
    input wire clk,
    input wire [1:0] status, // 2-bit status (e.g., error or done)
    output reg intr
);
    always @(posedge clk) begin
        if (status != 0) intr <= 1;
        else intr <= 0;
    end
endmodule