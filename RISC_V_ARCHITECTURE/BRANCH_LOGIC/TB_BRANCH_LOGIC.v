// TESTBENCH FOR BRANCH LOGIC

`timescale 1ns/1ps

module tb_BRANCH_LOGIC;

reg [31:0] pc;
reg [31:0] immediate;

reg branch;
reg zero;

wire [31:0] branch_target;
wire branch_taken;


// DUT INSTANTIATION

BRANCH_LOGIC DUT
(
   .pc(pc),
   .immediate(immediate),

   .branch(branch),
   .zero(zero),

   .branch_target(branch_target),
   .branch_taken(branch_taken)
);


initial begin

$display("--------------------------------------------------------------------------");
$display("                    BRANCH LOGIC TESTBENCH");
$display("--------------------------------------------------------------------------");
$display(" PC     IMMEDIATE    BRANCH    ZERO    BRANCH_TARGET    BRANCH_TAKEN");
$display("--------------------------------------------------------------------------");

$monitor("%4d       %4d         %b        %b          %4d              %b",
         pc,
         $signed(immediate),
         branch,
         zero,
         branch_target,
         branch_taken);


   // ------------------------------------------------
   // TEST 1 : NOT A BRANCH INSTRUCTION
   //
   // branch = 0
   // zero   = 0
   //
   // Expected:
   // branch_target = 108
   // branch_taken  = 0
   // ------------------------------------------------

   pc        = 32'd100;
   immediate = 32'd8;

   branch = 1'b0;
   zero   = 1'b0;

   #100;


   // ------------------------------------------------
   // TEST 2 : ZERO = 1 BUT NOT A BRANCH
   //
   // This checks that zero alone cannot cause
   // a branch.
   //
   // Expected:
   // branch_taken = 0
   // ------------------------------------------------

   pc        = 32'd100;
   immediate = 32'd8;

   branch = 1'b0;
   zero   = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 3 : BEQ BUT REGISTERS ARE NOT EQUAL
   //
   // branch = 1
   // zero   = 0
   //
   // Expected:
   // branch_taken = 0
   // ------------------------------------------------

   pc        = 32'd200;
   immediate = 32'd16;

   branch = 1'b1;
   zero   = 1'b0;

   #100;


   // ------------------------------------------------
   // TEST 4 : BEQ AND REGISTERS ARE EQUAL
   //
   // branch = 1
   // zero   = 1
   //
   // Expected:
   // branch_target = 216
   // branch_taken  = 1
   // ------------------------------------------------

   pc        = 32'd200;
   immediate = 32'd16;

   branch = 1'b1;
   zero   = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 5 : FORWARD BRANCH TARGET
   //
   // PC = 400
   // Immediate = +20
   //
   // Expected:
   // branch_target = 420
   // branch_taken  = 1
   // ------------------------------------------------

   pc        = 32'd400;
   immediate = 32'd20;

   branch = 1'b1;
   zero   = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 6 : BACKWARD BRANCH TARGET
   //
   // PC = 400
   // Immediate = -20
   //
   // Expected:
   // branch_target = 380
   // branch_taken  = 1
   //
   // Tests signed negative branch offset.
   // ------------------------------------------------

   pc        = 32'd400;
   immediate = -32'sd20;

   branch = 1'b1;
   zero   = 1'b1;

   #100;


$display("--------------------------------------------------------------------------");
$display("               BRANCH LOGIC TEST COMPLETED");
$display("--------------------------------------------------------------------------");

$stop;

end

endmodule