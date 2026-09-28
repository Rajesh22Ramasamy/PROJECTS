// EX_MEM_REGISTER


// EX MEM PIPELINE REGISTER

module EX_MEM_REGISTER
(
   input wire clk,
   input wire reset,

   // Data from EX stage
   input wire [31:0] alu_result,
   input wire [31:0] store_data,    // id_ex_read_data2 (for the SW function)
   input wire [4:0]  rd,
   input wire        zero,

   // Control signals
   input wire reg_write,
   input wire mem_read,
   input wire mem_write,
   input wire mem_to_reg,
   input wire branch,

   // Outputs to MEM stage
   output reg [31:0] ex_mem_alu_result,
   output reg [31:0] ex_mem_store_data,
   output reg [4:0]  ex_mem_rd,
   output reg        ex_mem_zero,

   output reg ex_mem_reg_write,
   output reg ex_mem_mem_read,
   output reg ex_mem_mem_write,
   output reg ex_mem_mem_to_reg,
   output reg ex_mem_branch
);

always @(posedge clk) begin

   if (reset) begin

      ex_mem_alu_result <= 32'd0;
      ex_mem_store_data <= 32'd0;
      ex_mem_rd         <= 5'd0;
      ex_mem_zero       <= 1'b0;

      ex_mem_reg_write  <= 1'b0;
      ex_mem_mem_read   <= 1'b0;
      ex_mem_mem_write  <= 1'b0;
      ex_mem_mem_to_reg <= 1'b0;
      ex_mem_branch     <= 1'b0;

   end

   else begin

      ex_mem_alu_result <= alu_result;
      ex_mem_store_data <= store_data;
      ex_mem_rd         <= rd;
      ex_mem_zero       <= zero;

      ex_mem_reg_write  <= reg_write;
      ex_mem_mem_read   <= mem_read;
      ex_mem_mem_write  <= mem_write;
      ex_mem_mem_to_reg <= mem_to_reg;
      ex_mem_branch     <= branch;

   end

end

endmodule