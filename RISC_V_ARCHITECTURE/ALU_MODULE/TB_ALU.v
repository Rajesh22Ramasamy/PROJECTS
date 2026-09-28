// TESTBENCH FOR ALU MODULE

`timescale 1ns/1ps

module tb_ALU;

reg  [31:0] operand_A;
reg  [31:0] operand_B;
reg  [3:0]  alu_operation;

wire [31:0] alu_result;
wire        zero;


// DUT INSTANTIATION

ALU DUT
(
   .operand_A(operand_A),
   .operand_B(operand_B),
   .alu_operation(alu_operation),

   .alu_result(alu_result),
   .zero(zero)
);


initial begin

$display("------------------------------------------------");
$display("               ALU TESTBENCH");
$display("------------------------------------------------");
$display(" A      B      ALU_OP      RESULT      ZERO");
$display("------------------------------------------------");

$monitor("%4d   %4d     %b       %d       %b",                                               
         $signed(operand_A),
         $signed(operand_B),
         alu_operation,
         alu_result,
         zero);

   // ------------------------------------------------
   // TEST 1 : ADD
   // 10 + 5 = 15
   // ------------------------------------------------

   operand_A     = 32'd10;
   operand_B     = 32'd5;
   alu_operation = 4'b0000;

   #100;


   // ------------------------------------------------
   // TEST 2 : SUB
   // 10 - 5 = 5
   // ------------------------------------------------

   operand_A     = 32'd10;
   operand_B     = 32'd5;
   alu_operation = 4'b0001;

   #100;


   // ------------------------------------------------
   // TEST 3 : SUB producing ZERO
   // 10 - 10 = 0
   // Used for BEQ comparison
   // ------------------------------------------------

   operand_A     = 32'd10;
   operand_B     = 32'd10;
   alu_operation = 4'b0001;

   #100;


   // ------------------------------------------------
   // TEST 4 : AND
   // 12 = 1100
   // 10 = 1010
   // AND = 1000 = 8
   // ------------------------------------------------

   operand_A     = 32'd12;
   operand_B     = 32'd10;
   alu_operation = 4'b0010;

   #100;


   // ------------------------------------------------
   // TEST 5 : OR
   // 12 = 1100
   // 10 = 1010
   // OR = 1110 = 14
   // ------------------------------------------------

   operand_A     = 32'd12;
   operand_B     = 32'd10;
   alu_operation = 4'b0011;

   #100;


   // ------------------------------------------------
   // TEST 6 : XOR
   // 12 = 1100
   // 10 = 1010
   // XOR = 0110 = 6
   // ------------------------------------------------

   operand_A     = 32'd12;
   operand_B     = 32'd10;
   alu_operation = 4'b0100;

   #100;


   // ------------------------------------------------
   // TEST 7 : SLT
   // 5 < 10 → TRUE
   // Result = 1
   // ------------------------------------------------

   operand_A     = 32'd5;
   operand_B     = 32'd10;
   alu_operation = 4'b0101;

   #100;


   // ------------------------------------------------
   // TEST 8 : SLT
   // 10 < 5 → FALSE
   // Result = 0
   // ------------------------------------------------

   operand_A     = 32'd10;
   operand_B     = 32'd5;
   alu_operation = 4'b0101;

   #100;


   // ------------------------------------------------
   // TEST 9 : SIGNED SLT
   // -5 < 3 → TRUE
   // Result = 1
   // ------------------------------------------------

   operand_A     = -32'sd5;
   operand_B     = 32'd3;
   alu_operation = 4'b0101;

   #100;


   // ------------------------------------------------
   // TEST 10 : DEFAULT / INVALID OPERATION
   // Should produce 0
   // ------------------------------------------------

   operand_A     = 32'd10;
   operand_B     = 32'd5;
   alu_operation = 4'b1111;

   #100;


   $display("---------------------------------------------------------");
   $display("              ALU TEST COMPLETED");
   $display("---------------------------------------------------------");

   $stop;

end

endmodule