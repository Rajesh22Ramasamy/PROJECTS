// Test Bench For PIPELINED RISC V ARCHITECTURE


`timescale 1ns/1ps

module tb_RISC_V_PIPELINED_PROCESSOR;

reg clk;
reg reset;


// DUT
RISC_V_PIPELINED_PROCESSOR DUT
(
   .clk(clk),
   .reset(reset)
);


// 10 ns clock period
always #5 clk = ~clk;


initial begin

   clk   = 1'b0;
   reset = 1'b1;

   // Hold reset for 20 ns
   #20;

   reset = 1'b0;

   // Run long enough for all instructions
   #400;


   $display("");
   $display("-----------------------------------");
   $display("FINAL REGISTER VALUES");
   $display("-----------------------------------");

   $display("x1 = %0d", DUT.REG_FILE.registers[1]);
   $display("x2 = %0d", DUT.REG_FILE.registers[2]);
   $display("x3 = %0d", DUT.REG_FILE.registers[3]);
   $display("x4 = %0d", DUT.REG_FILE.registers[4]);
   $display("x5 = %0d", DUT.REG_FILE.registers[5]);
   $display("x6 = %0d", DUT.REG_FILE.registers[6]);
   $display("x7 = %0d", DUT.REG_FILE.registers[7]);
   $display("x8 = %0d", DUT.REG_FILE.registers[8]);
   $display("x9 = %0d", DUT.REG_FILE.registers[9]);


   $display("");
   $display("-----------------------------------");
   $display("DATA MEMORY");
   $display("-----------------------------------");

   $display("Memory[0] = %0d",
            DUT.DATA_MEM.data_memory[0]);


   $display("");
   $display("-----------------------------------");
   $display("PROCESSOR TEST COMPLETED");
   $display("-----------------------------------");

   $stop;

end


initial begin

   $monitor(
      "Time=%0t | PC=%0d | Instruction=%h | Stall=%b | BranchTaken=%b",
      $time,
      DUT.pc,
      DUT.instruction,
      DUT.control_stall,
      DUT.branch_taken
   );

end

endmodule