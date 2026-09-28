// TESTBENCH FOR HAZARD DETECTION UNIT

`timescale 1ns/1ps

module tb_HAZARD_DETECTION_UNIT;

reg       id_ex_mem_read;
reg [4:0] id_ex_rd;
reg [4:0] if_id_rs1;
reg [4:0] if_id_rs2;

wire pc_write;
wire if_id_write;
wire control_stall;


// DUT INSTANTIATION

HAZARD_DETECTION_UNIT DUT
(
   .id_ex_mem_read(id_ex_mem_read),
   .id_ex_rd(id_ex_rd),
   .if_id_rs1(if_id_rs1),
   .if_id_rs2(if_id_rs2),

   .pc_write(pc_write),
   .if_id_write(if_id_write),
   .control_stall(control_stall)
);


initial begin

$display("--------------------------------------------------------------------------------");
$display("                    HAZARD DETECTION UNIT TESTBENCH");
$display("--------------------------------------------------------------------------------");
$display(" MEM_READ   ID_EX_RD   IF_ID_RS1   IF_ID_RS2   PC_WRITE   IF_ID_WRITE   STALL");
$display("--------------------------------------------------------------------------------");

$monitor("    %b         %2d          %2d          %2d          %b           %b          %b",
         id_ex_mem_read,
         id_ex_rd,
         if_id_rs1,
         if_id_rs2,
         pc_write,
         if_id_write,
         control_stall);


   // ------------------------------------------------
   // TEST 1 : NORMAL OPERATION
   //
   // No load instruction in EX stage.
   //
   // Expected:
   // pc_write      = 1
   // if_id_write   = 1
   // control_stall = 0
   // ------------------------------------------------

   id_ex_mem_read = 1'b0;
   id_ex_rd       = 5'd5;

   if_id_rs1      = 5'd1;
   if_id_rs2      = 5'd2;

   #100;


   // ------------------------------------------------
   // TEST 2 : LOAD-USE HAZARD ON RS1
   //
   // Example:
   //
   // LW  x5, 0(x2)
   // ADD x6, x5, x3
   //
   // id_ex_rd = x5
   // if_id_rs1 = x5
   //
   // Expected:
   // pc_write      = 0
   // if_id_write   = 0
   // control_stall = 1
   // ------------------------------------------------

   id_ex_mem_read = 1'b1;
   id_ex_rd       = 5'd5;

   if_id_rs1      = 5'd5;
   if_id_rs2      = 5'd3;

   #100;


   // ------------------------------------------------
   // TEST 3 : LOAD-USE HAZARD ON RS2
   //
   // Loaded destination matches rs2.
   //
   // Expected:
   // pc_write      = 0
   // if_id_write   = 0
   // control_stall = 1
   // ------------------------------------------------

   id_ex_mem_read = 1'b1;
   id_ex_rd       = 5'd7;

   if_id_rs1      = 5'd2;
   if_id_rs2      = 5'd7;

   #100;


   // ------------------------------------------------
   // TEST 4 : LOAD BUT NO DEPENDENCY
   //
   // LW writes x5
   // Current instruction uses x2 and x3
   //
   // Expected:
   // pc_write      = 1
   // if_id_write   = 1
   // control_stall = 0
   // ------------------------------------------------

   id_ex_mem_read = 1'b1;
   id_ex_rd       = 5'd5;

   if_id_rs1      = 5'd2;
   if_id_rs2      = 5'd3;

   #100;


   // ------------------------------------------------
   // TEST 5 : BOTH RS1 AND RS2 MATCH
   //
   // Example:
   //
   // LW  x5, 0(x2)
   // ADD x6, x5, x5
   //
   // Expected:
   // pc_write      = 0
   // if_id_write   = 0
   // control_stall = 1
   // ------------------------------------------------

   id_ex_mem_read = 1'b1;
   id_ex_rd       = 5'd5;

   if_id_rs1      = 5'd5;
   if_id_rs2      = 5'd5;

   #100;


   // ------------------------------------------------
   // TEST 6 : DESTINATION IS x0
   //
   // x0 must be ignored.
   //
   // Even if source register is x0,
   // no hazard should be generated.
   //
   // Expected:
   // pc_write      = 1
   // if_id_write   = 1
   // control_stall = 0
   // ------------------------------------------------

   id_ex_mem_read = 1'b1;
   id_ex_rd       = 5'd0;

   if_id_rs1      = 5'd0;
   if_id_rs2      = 5'd3;

   #100;


   // ------------------------------------------------
   // TEST 7 : REGISTER MATCH BUT NOT A LOAD
   //
   // rd matches rs1, but MemRead = 0.
   //
   // This dependency can normally be handled
   // by the Forwarding Unit.
   //
   // Expected:
   // pc_write      = 1
   // if_id_write   = 1
   // control_stall = 0
   // ------------------------------------------------

   id_ex_mem_read = 1'b0;
   id_ex_rd       = 5'd10;

   if_id_rs1      = 5'd10;
   if_id_rs2      = 5'd4;

   #100;


$display("--------------------------------------------------------------------------------");
$display("             HAZARD DETECTION UNIT TEST COMPLETED");
$display("--------------------------------------------------------------------------------");

$stop;

end

endmodule