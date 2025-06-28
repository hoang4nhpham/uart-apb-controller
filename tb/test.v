`timescale 1ns/1ps

module uart_controller_test;

//----------------- Registers to drive the inputs -----------------\\
reg        reset_n_tb;
reg        psel_tb;
reg        penable_tb;
reg        pwrite_tb;
reg [31:0] paddr_tb;
reg [31:0] pwdata_tb;
reg        RX_tb;
reg        pclk_tb; // Khai báo pclk_tb là reg ?? t?o xung clock

//----------------- Wires to show the outputs -----------------\\
wire [31:0] prdata_tb;
wire        TX_tb;
wire        TX_DONE_tb;
wire        ERROR_tb;
wire        FULL_tb;

//----------------- DUT -----------------\\
uart_controller DUT (
    .pclk(pclk_tb),
    .presetn(reset_n_tb),
    .paddr(paddr_tb),
    .psel(psel_tb),
    .penable(penable_tb),
    .pwrite(pwrite_tb),
    .pwdata(pwdata_tb),
    .prdata(prdata_tb),
    .TX(TX_tb),
    .RX(RX_tb),
    .TX_DONE(TX_DONE_tb),
    .ERROR(ERROR_tb),
    .FULL(FULL_tb)
);

//----------------- Save wave form -----------------\\
initial begin
    $dumpfile("uart_controller_test.vcd");
    $dumpvars;
end

//----------------- Monitoring -----------------\\
initial begin
    $monitor($time, " Outputs: prdata=%h TX=%b TX_DONE=%b ERROR=%b FULL=%b   Inputs: reset_n=%b psel=%b penable=%b pwrite=%b paddr=%h pwdata=%h RX=%b",
             prdata_tb, TX_tb, TX_DONE_tb, ERROR_tb, FULL_tb,
             reset_n_tb, psel_tb, penable_tb, pwrite_tb, paddr_tb, pwdata_tb, RX_tb);
end

//----------------- System clock generator (50MHz) -----------------\\
initial begin
    pclk_tb = 1'b0;
    forever #10 pclk_tb = ~pclk_tb; // 20ns period = 50MHz
end

//----------------- Resetting the system -----------------\\
initial begin
    reset_n_tb = 1'b0;
    #20 reset_n_tb = 1'b1;
end

//----------------- Test NO.1: Write and transmit data 0xAA -----------------\\
initial begin
    psel_tb = 0; penable_tb = 0; pwrite_tb = 0; paddr_tb = 0; pwdata_tb = 0; RX_tb = 1;
    #50;
    psel_tb = 1; penable_tb = 1; pwrite_tb = 1; paddr_tb = 32'h00000000; pwdata_tb = 32'hAA;
    #40;
    pwrite_tb = 0;
    #20000; // Wait for 20µs (?? cho 9600 baud)
end

//----------------- Test NO.2: Receive data 0x55 with parity and stop -----------------\\
initial begin
    #250;
    // Simulate RX: Start(0), Data(01010101), Parity(0 for odd), Stop(1) at 9600 baud
    RX_tb = 0; // Start
    #104167 RX_tb = 0; #104167 RX_tb = 1; #104167 RX_tb = 0; #104167 RX_tb = 1; // 0101
    #104167 RX_tb = 0; #104167 RX_tb = 1; #104167 RX_tb = 0; #104167 RX_tb = 1; // 0101
    #104167 RX_tb = 0; // Parity odd for 0x55
    #104167 RX_tb = 1; // Stop
    #104167;
end

//----------------- Test NO.3: Error case (wrong stop bit) -----------------\\
initial begin
    #50000;
    // Simulate RX with wrong stop bit
    RX_tb = 0; // Start
    #104167 RX_tb = 0; #104167 RX_tb = 1; #104167 RX_tb = 0; #104167 RX_tb = 1; // 0101
    #104167 RX_tb = 0; #104167 RX_tb = 1; #104167 RX_tb = 0; #104167 RX_tb = 1; // 0101
    #104167 RX_tb = 0; // Parity
    #104167 RX_tb = 0; // Wrong stop (should be 1)
    #104167;
end

//----------------- Stop simulation -----------------\\
initial begin
  #300000000 $stop;
end

endmodule