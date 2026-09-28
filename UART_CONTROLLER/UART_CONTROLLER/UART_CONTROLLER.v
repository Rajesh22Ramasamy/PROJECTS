// UART CONTROLLER MAIN MODULE



module UART_CONTROLLER
(
    input wire clk,
    input wire reset,

    input wire [7:0] tx_data,
    input wire tx_start,

    input wire rx,

    output wire tx,
    output wire tx_busy,

    output wire [7:0] rx_data,
    output wire rx_done
);

wire baud_tick;
wire baud_restart;


// Baud Generator
BAUD_GENERATOR BAUD_GEN
(
    .clk(clk),
    .reset(reset),
    .baud_restart(baud_restart),
    .baud_tick(baud_tick)
);


// Transmitter
TX_MODULE TX
(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .tx(tx),
    .tx_busy(tx_busy),
    .baud_restart(baud_restart)
);


// Receiver
RX_MODULE RX
(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

endmodule