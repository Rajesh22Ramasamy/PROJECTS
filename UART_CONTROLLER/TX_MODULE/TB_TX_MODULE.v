// Test Bench for TX Module

`timescale 1ns/1ps

module tb_TX_MODULE;

//--------------------------------------------------
// Testbench signals
//--------------------------------------------------

reg clk;
reg reset;

reg [7:0] tx_data;
reg tx_start;

wire baud_tick;
wire baud_restart;
wire tx;
wire tx_busy;


//--------------------------------------------------
// BAUD GENERATOR DUT
//--------------------------------------------------

BAUD_GENERATOR BAUD_DUT
(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .baud_restart(baud_restart)
);


//--------------------------------------------------
// TRANSMITTER DUT
//--------------------------------------------------

TX_MODULE TX_DUT
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


//--------------------------------------------------
// Clock Generation
//--------------------------------------------------

// 20 ns clock period = 50 MHz clock

initial begin

    clk = 1'b0;

    forever #10 clk = ~clk;

end


//--------------------------------------------------
// Test Sequence
//--------------------------------------------------

initial begin

    // Initial values

    reset    = 1'b1;
    tx_start = 1'b0;
    tx_data  = 8'd0;


    // Hold reset for a few clock cycles

    #100;

    reset = 1'b0;


    // Wait before starting transmission

    #100;


    //------------------------------------------------
    // TEST 1
    // Transmit ASCII 'A'
    //
    // ASCII A = 0100_0001
    //------------------------------------------------

    tx_data = 8'b0100_0001;

    // Generate one-clock-cycle tx_start pulse

    tx_start = 1'b1;

    #20;

    tx_start = 1'b0;


    //------------------------------------------------
    // Wait for transmission to complete
    //------------------------------------------------

    wait(tx_busy == 1'b1);

    wait(tx_busy == 1'b0);


    // Wait a little longer

    #200;


    //------------------------------------------------
    // End simulation
    //------------------------------------------------

    $stop;

end


//--------------------------------------------------
// Monitor
//--------------------------------------------------

initial begin

    $monitor(
        "Time=%0t | reset=%b | tx_start=%b | tx_data=%b | baud_tick=%b | baud_restart=%b | tx_busy=%b | tx=%b",
        $time,
        reset,
        tx_start,
        tx_data,
        baud_tick,
        baud_restart,
        tx_busy,
        tx
    );

end

endmodule