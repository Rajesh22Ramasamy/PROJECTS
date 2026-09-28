// TEST BENCH for BAUD GENERATOR

`timescale 1ns/1ps

module tb_UART_CONTROLLER;

reg clk;
reg reset;
reg [7:0] tx_data;
reg tx_start;

wire tx;
wire tx_busy;
wire [7:0] rx_data;
wire rx_done;

// Loopback connection
wire rx;
assign rx = tx;


// DUT
UART_CONTROLLER DUT
(
    .clk(clk),
    .reset(reset),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .rx(rx),
    .tx(tx),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .rx_done(rx_done)
);


// 50 MHz clock
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end


initial begin

    reset    = 1'b1;
    tx_start = 1'b0;
    tx_data  = 8'd0;

    #100;

    reset = 1'b0;

    #100;


    // -----------------------------
    // TEST 1 : ASCII A = 8'h41
    // -----------------------------

    tx_data  = 8'h41;
    tx_start = 1'b1;

    #20;

    tx_start = 1'b0;

    wait(rx_done == 1'b1);

    if (rx_data == 8'h41)
        $display("TEST 1 PASS : TX = %h, RX = %h", tx_data, rx_data);
    else
        $display("TEST 1 FAIL : Expected 41, Received %h", rx_data);


    // Wait before next transmission
    wait(tx_busy == 1'b0);

     #20;

    // -----------------------------
    // TEST 2 : 8'hA5
    // -----------------------------

    tx_data  = 8'hA5;
    tx_start = 1'b1;

    #20;

    tx_start = 1'b0;

    wait(rx_done == 1'b1);

    if (rx_data == 8'hA5)
        $display("TEST 2 PASS : TX = %h, RX = %h", tx_data, rx_data);
    else
        $display("TEST 2 FAIL : Expected A5, Received %h", rx_data);


    wait(tx_busy == 1'b0);

     #20;


    // -----------------------------
    // TEST 3 : 8'hFF
    // -----------------------------

    tx_data  = 8'hFF;
    tx_start = 1'b1;

    #20;

    tx_start = 1'b0;

    wait(rx_done == 1'b1);

    if (rx_data == 8'hFF)
        $display("TEST 3 PASS : TX = %h, RX = %h", tx_data, rx_data);
    else
        $display("TEST 3 FAIL : Expected FF, Received %h", rx_data);


    #200;

    $stop;

end


initial begin

    $monitor(
        "Time=%0t | tx_start=%b | tx_busy=%b | tx=%b | rx=%b | rx_data=%h | rx_done=%b",
        $time,
        tx_start,
        tx_busy,
        tx,
        rx,
        rx_data,
        rx_done
    );

end

endmodule