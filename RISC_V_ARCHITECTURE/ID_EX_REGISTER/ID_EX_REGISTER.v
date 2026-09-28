// ID EX PIPELINE REGISTER

// ID/EX PIPELINE REGISTER

module ID_EX_REGISTER
(
   input wire clk,
   input wire reset,
   input wire flush,

   input wire [31:0] id_pc,
   input wire [31:0] read_data1,
   input wire [31:0] read_data2,
   input wire [31:0] immediate,

   input wire [4:0] rs1,
   input wire [4:0] rs2,
   input wire [4:0] rd,

   input wire [2:0] funct3,
   input wire [6:0] funct7,

   input wire reg_write,
   input wire alu_src,
   input wire mem_read,
   input wire mem_write,
   input wire mem_to_reg,
   input wire branch,
   input wire [1:0] alu_op,

   output reg [31:0] id_ex_pc,
   output reg [31:0] id_ex_read_data1,
   output reg [31:0] id_ex_read_data2,
   output reg [31:0] id_ex_immediate,

   output reg [4:0] id_ex_rs1,
   output reg [4:0] id_ex_rs2,
   output reg [4:0] id_ex_rd,

   output reg [2:0] id_ex_funct3,
   output reg [6:0] id_ex_funct7,

   output reg id_ex_reg_write,
   output reg id_ex_alu_src,
   output reg id_ex_mem_read,
   output reg id_ex_mem_write,
   output reg id_ex_mem_to_reg,
   output reg id_ex_branch,
   output reg [1:0] id_ex_alu_op
);

always @(posedge clk) begin

   if (reset || flush) begin

      id_ex_pc            <= 32'd0;
      id_ex_read_data1    <= 32'd0;
      id_ex_read_data2    <= 32'd0;
      id_ex_immediate     <= 32'd0;

      id_ex_rs1           <= 5'd0;
      id_ex_rs2           <= 5'd0;
      id_ex_rd            <= 5'd0;

      id_ex_funct3        <= 3'd0;
      id_ex_funct7        <= 7'd0;

      id_ex_reg_write     <= 1'b0;
      id_ex_alu_src       <= 1'b0;
      id_ex_mem_read      <= 1'b0;
      id_ex_mem_write     <= 1'b0;
      id_ex_mem_to_reg    <= 1'b0;
      id_ex_branch        <= 1'b0;
      id_ex_alu_op        <= 2'b00;

   end

   else begin

      id_ex_pc            <= id_pc;
      id_ex_read_data1    <= read_data1;
      id_ex_read_data2    <= read_data2;
      id_ex_immediate     <= immediate;

      id_ex_rs1           <= rs1;
      id_ex_rs2           <= rs2;
      id_ex_rd            <= rd;

      id_ex_funct3        <= funct3;
      id_ex_funct7        <= funct7;

      id_ex_reg_write     <= reg_write;
      id_ex_alu_src       <= alu_src;
      id_ex_mem_read      <= mem_read;
      id_ex_mem_write     <= mem_write;
      id_ex_mem_to_reg    <= mem_to_reg;
      id_ex_branch        <= branch;
      id_ex_alu_op        <= alu_op;

   end

end

endmodule