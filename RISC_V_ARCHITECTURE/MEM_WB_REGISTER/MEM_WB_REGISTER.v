// MEM/WB PIPELINE REGISTER

module MEM_WB_REGISTER
(
   input wire clk,
   input wire reset,

   // Data from MEM stage
   input wire [31:0] read_data,
   input wire [31:0] alu_result,
   input wire [4:0]  rd,

   // Control signals
   input wire reg_write,
   input wire mem_to_reg,

   // Outputs to Write Back (WB) stage
   output reg [31:0] mem_wb_read_data,
   output reg [31:0] mem_wb_alu_result,
   output reg [4:0]  mem_wb_rd,

   output reg mem_wb_reg_write,
   output reg mem_wb_mem_to_reg
);

always @(posedge clk) begin

   if (reset) begin

      mem_wb_read_data  <= 32'd0;
      mem_wb_alu_result <= 32'd0;
      mem_wb_rd         <= 5'd0;

      mem_wb_reg_write  <= 1'b0;
      mem_wb_mem_to_reg <= 1'b0;

   end

   else begin

      mem_wb_read_data  <= read_data;
      mem_wb_alu_result <= alu_result;
      mem_wb_rd         <= rd;

      mem_wb_reg_write  <= reg_write;
      mem_wb_mem_to_reg <= mem_to_reg;

   end

end

endmodule