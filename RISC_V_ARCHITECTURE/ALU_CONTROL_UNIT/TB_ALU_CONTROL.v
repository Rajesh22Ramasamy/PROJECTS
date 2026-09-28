// TESTBENCH FOR ALU CONTROL UNIT

`timescale 1ns/1ps

module tb_ALU_CONTROL;

reg [1:0] alu_op;
reg [2:0] funct3;	
reg [6:0] funct7;

wire [3:0] alu_control;


// DUT INSTANTIATION

ALU_CONTROL DUT
(
   .alu_op(alu_op),
   .funct3(funct3),
   .funct7(funct7),

   .alu_control(alu_control)
);


initial begin

$display("--------------------------------------------------------------");
$display("                 ALU CONTROL TESTBENCH");
$display("--------------------------------------------------------------");
$display(" ALU_OP     FUNCT3      FUNCT7       ALU_CONTROL");
$display("--------------------------------------------------------------");

$monitor("   %b        %b      %b          %b",
         alu_op,
         funct3,
         funct7,
         alu_control);


   // ------------------------------------------------
   // TEST 1 : LW / SW
   // ALU_OP = 00
   // Expected operation = ADD
   // Expected ALU_CONTROL = 0000
   // ------------------------------------------------

   alu_op = 2'b00;
   funct3 = 3'b000;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 2 : BEQ
   // ALU_OP = 01
   // Expected operation = SUB
   // Expected ALU_CONTROL = 0001
   // ------------------------------------------------

   alu_op = 2'b01;
   funct3 = 3'b000;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 3 : R-TYPE ADD
   // funct3 = 000
   // funct7 = 0000000
   // Expected ALU_CONTROL = 0000
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b000;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 4 : R-TYPE SUB
   // funct3 = 000
   // funct7 = 0100000
   // Expected ALU_CONTROL = 0001
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b000;
   funct7 = 7'b0100000;

   #100;


   // ------------------------------------------------
   // TEST 5 : R-TYPE AND
   // funct3 = 111
   // Expected ALU_CONTROL = 0010
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b111;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 6 : R-TYPE OR
   // funct3 = 110
   // Expected ALU_CONTROL = 0011
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b110;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 7 : R-TYPE XOR
   // funct3 = 100
   // Expected ALU_CONTROL = 0100
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b100;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 8 : R-TYPE SLT
   // funct3 = 010
   // Expected ALU_CONTROL = 0101
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b010;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 9 : I-TYPE ADDI
   // ALU_OP = 11
   // Expected operation = ADD
   // Expected ALU_CONTROL = 0000
   // ------------------------------------------------

   alu_op = 2'b11;
   funct3 = 3'b000;
   funct7 = 7'b0000000;

   #100;


   // ------------------------------------------------
   // TEST 10 : INVALID R-TYPE FUNCT3
   // Default expected ALU_CONTROL = 0000
   // ------------------------------------------------

   alu_op = 2'b10;
   funct3 = 3'b001;
   funct7 = 7'b0000000;

   #100;


$display("--------------------------------------------------------------");
$display("              ALU CONTROL TEST COMPLETED");
$display("--------------------------------------------------------------");

$stop;

end

endmodule