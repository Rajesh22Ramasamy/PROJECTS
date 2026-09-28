// FORWARDING UNIT


module FORWARDING_UNIT
(
   input wire [4:0] id_ex_rs1,
   input wire [4:0] id_ex_rs2,

   input wire [4:0] ex_mem_rd,
   input wire       ex_mem_reg_write,

   input wire [4:0] mem_wb_rd,
   input wire       mem_wb_reg_write,

   output reg [1:0] forward_A,
   output reg [1:0] forward_B
);

always @(*) begin

   // Default: no forwarding
   forward_A = 2'b00;
   forward_B = 2'b00;


   // Forward to ALU operand A from EX/MEM
   if (ex_mem_reg_write &&
       (ex_mem_rd != 5'd0) &&
       (ex_mem_rd == id_ex_rs1)) begin

      forward_A = 2'b10;

   end

   // Otherwise forward to operand A from MEM/WB
   else if (mem_wb_reg_write &&
            (mem_wb_rd != 5'd0) &&
            (mem_wb_rd == id_ex_rs1)) begin

      forward_A = 2'b01;

   end


   // Forward to ALU operand B from EX/MEM
   if (ex_mem_reg_write &&
       (ex_mem_rd != 5'd0) &&
       (ex_mem_rd == id_ex_rs2)) begin

      forward_B = 2'b10;

   end

   // Otherwise forward to operand B from MEM/WB
   else if (mem_wb_reg_write &&
            (mem_wb_rd != 5'd0) &&
            (mem_wb_rd == id_ex_rs2)) begin

      forward_B = 2'b01;

   end

end

endmodule