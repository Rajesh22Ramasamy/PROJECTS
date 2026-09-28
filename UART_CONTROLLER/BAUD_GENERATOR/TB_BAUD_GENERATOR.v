// TEST BENCH FOR BAUD_GENERATOR

// Testbench for BAUD GENERATOR

module tb_BAUD_GENERATOR();

reg clk;
reg reset;
wire baud_tick;

// DUT Instantiation
BAUD_GENERATOR DUT
(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

// Clock generation: 50 MHz (period = 20 ns)
initial begin
    clk = 0;
    forever #10 clk = ~clk;  // Toggle every 10 ns
end

initial begin
    $display("BAUD GENERATOR TESTBENCH");
    $display("Time | reset | Count | baud_tick");
    $monitor("%0t | %b | %d | %b", $time, reset, DUT.count, baud_tick);

    // Apply reset
    reset = 1;
    #50;
    reset = 0;

    // Run long enough to observe several baud_tick pulses
    #200000;   // Adjust depending on simulator
    $stop;
end

endmodule
