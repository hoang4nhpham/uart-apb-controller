`timescale 1ns/1ps

module uart_controller (
    input wire pclk,
    input wire presetn,
    input wire [31:0] paddr,
    input wire psel,
    input wire penable,
    input wire pwrite,
    input wire [31:0] pwdata,
    output wire [31:0] prdata,
    output wire TX,
    input wire RX,
    output wire TX_DONE,
    output wire ERROR,
    output wire FULL
);

    // Tín hi?u trung gian
    wire cs, wm;
    wire [3:0] addr;
    wire [7:0] wdata;
    wire [10:0] reg_rdata;
    wire intr;
    wire baud_clk;
    wire [7:0] tx_fifo_data_out;
    wire tx_fifo_empty;
    wire [10:0] rx_fifo_data_out;
    wire rx_fifo_full;
    wire rx_valid;
    wire [10:0] rx_engine_data_out;

    // Module con
    apb_slave apb_inst (
        .pclk(pclk),
        .presetn(presetn),
        .pwrite(pwrite),
        .paddr(paddr[3:0]),
        .pwdata(pwdata[7:0]),
        .prdata(reg_rdata),
        .cs(cs),
        .wm(wm),
        .addr(addr),
        .wdata(wdata)
    );

    register_bank reg_bank_inst (
        .clk(pclk),
        .cs(cs),
        .wm(wm),
        .addr(addr),
        .wdata(wdata),
        .rdata(reg_rdata)
    );

    interrupt_handler int_handler_inst (
        .clk(pclk),
        .status({rx_valid, tx_fifo_empty}),
        .intr(intr)
    );

    baud_rate_generator baud_gen_inst (
        .clk(pclk),
        .reset(~presetn),
        .baud_clk(baud_clk)
    );

    transmitter_fifo tx_fifo_inst (
        .clk(pclk),
        .reset(~presetn),
        .wr_en(cs && wm && (addr == 4'h0)),
        .data_in(wdata),
        .data_out(tx_fifo_data_out),
        .empty(tx_fifo_empty)
    );

    transmitter_engine tx_engine_inst (
        .clk(baud_clk),
        .reset(~presetn),
        .data_in(tx_fifo_data_out),
        .TX(TX),
        .tx_done(TX_DONE)
    );

    receiver_fifo rx_fifo_inst (
        .clk(pclk),
        .reset(~presetn),
        .wr_en(rx_valid),
        .data_in(rx_engine_data_out),
        .data_out(rx_fifo_data_out),
        .full(FULL)
    );

    receiver_engine rx_engine_inst (
        .clk(baud_clk),
        .reset(~presetn),
        .RX(RX),
        .data_out(rx_engine_data_out),
        .rx_valid(rx_valid)
    );

    // Gán tín hi?u ERROR t? Interrupt Handler ho?c tr?ng thái l?i
    assign ERROR = intr && (|rx_fifo_data_out[10:8]); // Kích ho?t khi có l?i (bit 10-8)

    // M? r?ng prdata lên 32-bit
    assign prdata = {21'b0, reg_rdata};

endmodule