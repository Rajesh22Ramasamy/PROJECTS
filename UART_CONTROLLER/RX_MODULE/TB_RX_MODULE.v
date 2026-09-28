// Test bench for RX_MODULE

`timescale 1ns/1ps

module tb_RX_MODULE;

reg clk;
reg reset;
reg rx;

wire [7:0] rx_data;
wire rx_done;


// DUT
RX_MODULE DUT
(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);


// 50 MHz clock
// Period = 20 ns

initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end


initial begin

    // Initial conditions
    reset = 1'b1;
    rx    = 1'b1;       // UART idle = HIGH

    #100;

    reset = 1'b0;

    #100;


    //-----------------------------------------
    // Send UART frame for 8'b0100_0001
    //-----------------------------------------


    // START
    rx = 1'b0;
    #1000;


    // D0 = 1
    rx = 1'b1;
    #1000;


    // D1 = 0
    rx = 1'b0;
    #1000;


    // D2 = 0
    rx = 1'b0;
    #1000;


    // D3 = 0
    rx = 1'b0;
    #1000;


    // D4 = 0
    rx = 1'b0;
    #1000;


    // D5 = 0
    rx = 1'b0;
    #1000;


    // D6 = 1
    rx = 1'b1;
    #1000;


    // D7 = 0
    rx = 1'b0;
    #1000;


    // STOP
    rx = 1'b1;
    #1000;


    // Remain IDLE
    #500;


    $stop;

end


initial begin

    $monitor(
        "Time=%0t | rx=%b | rx_data=%b | rx_done=%b",
        $time,
        rx,
        rx_data,
        rx_done
    );

end

endmodule