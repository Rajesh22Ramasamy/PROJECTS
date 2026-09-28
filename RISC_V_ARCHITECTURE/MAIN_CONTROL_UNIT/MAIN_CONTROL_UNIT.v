// MAIN CONTROL UNIT

module MAIN_CONTROL
(
   input wire [6:0] opcode,

   output reg reg_write,
   output reg alu_src,
   output reg mem_read,
   output reg mem_write,
   output reg mem_to_reg,
   output reg branch,
   output reg [1:0] alu_op
);

always @(*) begin

   // Default values
   reg_write  = 1'b0;
   alu_src    = 1'b0;
   mem_read   = 1'b0;
   mem_write  = 1'b0;
   mem_to_reg = 1'b0;
   branch     = 1'b0;
   alu_op     = 2'b00;

   case (opcode)

      // R-TYPE: ADD, SUB, AND, OR, XOR, SLT
      7'b0110011: begin
         reg_write  = 1'b1;
         alu_src    = 1'b0;
         mem_read   = 1'b0;
         mem_write  = 1'b0;
         mem_to_reg = 1'b0;
         branch     = 1'b0;
         alu_op     = 2'b10;
      end

      // I-TYPE: ADDI
      7'b0010011: begin
         reg_write  = 1'b1;
         alu_src    = 1'b1;
         mem_read   = 1'b0;
         mem_write  = 1'b0;
         mem_to_reg = 1'b0;
         branch     = 1'b0;
         alu_op     = 2'b11;
      end

      // LW
      7'b0000011: begin
         reg_write  = 1'b1;
         alu_src    = 1'b1;
         mem_read   = 1'b1;
         mem_write  = 1'b0;
         mem_to_reg = 1'b1;
         branch     = 1'b0;
         alu_op     = 2'b00;
      end

      // SW
      7'b0100011: begin
         reg_write  = 1'b0;
         alu_src    = 1'b1;
         mem_read   = 1'b0;
         mem_write  = 1'b1;
         mem_to_reg = 1'b0;
         branch     = 1'b0;
         alu_op     = 2'b00;
      end

      // BEQ
      7'b1100011: begin
         reg_write  = 1'b0;
         alu_src    = 1'b0;
         mem_read   = 1'b0;
         mem_write  = 1'b0;
         mem_to_reg = 1'b0;
         branch     = 1'b1;
         alu_op     = 2'b01;
      end

   endcase

end

endmodule