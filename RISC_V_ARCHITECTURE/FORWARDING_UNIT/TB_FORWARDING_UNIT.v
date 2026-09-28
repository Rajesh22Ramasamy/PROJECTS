// TESTBENCH FOR FORWARDING UNIT

`timescale 1ns/1ps

module tb_FORWARDING_UNIT;

reg [4:0] id_ex_rs1;
reg [4:0] id_ex_rs2;

reg [4:0] ex_mem_rd;
reg       ex_mem_reg_write;

reg [4:0] mem_wb_rd;
reg       mem_wb_reg_write;

wire [1:0] forward_A;
wire [1:0] forward_B;


// DUT INSTANTIATION

FORWARDING_UNIT DUT
(
   .id_ex_rs1(id_ex_rs1),
   .id_ex_rs2(id_ex_rs2),

   .ex_mem_rd(ex_mem_rd),
   .ex_mem_reg_write(ex_mem_reg_write),

   .mem_wb_rd(mem_wb_rd),
   .mem_wb_reg_write(mem_wb_reg_write),

   .forward_A(forward_A),
   .forward_B(forward_B)
);


initial begin

$display("--------------------------------------------------------------------------");
$display("                    FORWARDING UNIT TESTBENCH");
$display("--------------------------------------------------------------------------");
$display(" RS1  RS2   EX_RD EX_WE   WB_RD WB_WE   FORWARD_A FORWARD_B");
$display("--------------------------------------------------------------------------");

$monitor(" %2d   %2d     %2d    %b       %2d    %b        %b        %b",
         id_ex_rs1,
         id_ex_rs2,
         ex_mem_rd,
         ex_mem_reg_write,
         mem_wb_rd,
         mem_wb_reg_write,
         forward_A,
         forward_B);


   // ------------------------------------------------
   // TEST 1 : NO FORWARDING
   // Expected:
   // forward_A = 00
   // forward_B = 00
   // ------------------------------------------------

   id_ex_rs1 = 5'd1;
   id_ex_rs2 = 5'd2;

   ex_mem_rd = 5'd3;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd4;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 2 : FORWARD A FROM EX/MEM
   // EX/MEM rd matches rs1
   // Expected:
   // forward_A = 10
   // forward_B = 00
   // ------------------------------------------------

   id_ex_rs1 = 5'd5;
   id_ex_rs2 = 5'd2;

   ex_mem_rd = 5'd5;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd4;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 3 : FORWARD A FROM MEM/WB
   // MEM/WB rd matches rs1
   // Expected:
   // forward_A = 01
   // forward_B = 00
   // ------------------------------------------------

   id_ex_rs1 = 5'd6;
   id_ex_rs2 = 5'd2;

   ex_mem_rd = 5'd3;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd6;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 4 : FORWARD B FROM EX/MEM
   // EX/MEM rd matches rs2
   // Expected:
   // forward_A = 00
   // forward_B = 10
   // ------------------------------------------------

   id_ex_rs1 = 5'd1;
   id_ex_rs2 = 5'd7;

   ex_mem_rd = 5'd7;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd4;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 5 : FORWARD B FROM MEM/WB
   // MEM/WB rd matches rs2
   // Expected:
   // forward_A = 00
   // forward_B = 01
   // ------------------------------------------------

   id_ex_rs1 = 5'd1;
   id_ex_rs2 = 5'd8;

   ex_mem_rd = 5'd3;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd8;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 6 : FORWARD BOTH OPERANDS
   // rs1 matches EX/MEM
   // rs2 matches MEM/WB
   // Expected:
   // forward_A = 10
   // forward_B = 01
   // ------------------------------------------------

   id_ex_rs1 = 5'd9;
   id_ex_rs2 = 5'd10;

   ex_mem_rd = 5'd9;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd10;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 7 : EX/MEM PRIORITY OVER MEM/WB
   // Both destination registers match rs1
   //
   // EX/MEM contains newer result,
   // therefore forward_A must be 10
   // ------------------------------------------------

   id_ex_rs1 = 5'd11;
   id_ex_rs2 = 5'd2;

   ex_mem_rd = 5'd11;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd11;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 8 : rd = x0 MUST NOT FORWARD
   //
   // Even though rs1 = x0 and rd = x0,
   // x0 must always remain zero.
   //
   // Expected:
   // forward_A = 00
   // forward_B = 00
   // ------------------------------------------------

   id_ex_rs1 = 5'd0;
   id_ex_rs2 = 5'd2;

   ex_mem_rd = 5'd0;
   ex_mem_reg_write = 1'b1;

   mem_wb_rd = 5'd0;
   mem_wb_reg_write = 1'b1;

   #100;


   // ------------------------------------------------
   // TEST 9 : REG_WRITE DISABLED
   //
   // Destination register matches,
   // but RegWrite = 0.
   //
   // Therefore no forwarding.
   //
   // Expected:
   // forward_A = 00
   // forward_B = 00
   // ------------------------------------------------

   id_ex_rs1 = 5'd12;
   id_ex_rs2 = 5'd13;

   ex_mem_rd = 5'd12;
   ex_mem_reg_write = 1'b0;

   mem_wb_rd = 5'd13;
   mem_wb_reg_write = 1'b0;

   #100;


$display("--------------------------------------------------------------------------");
$display("               FORWARDING UNIT TEST COMPLETED");
$display("--------------------------------------------------------------------------");

$stop;

end

endmodule