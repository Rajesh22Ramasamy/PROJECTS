// IF ID REGISTER


// IF/ID PIPELINE REGISTER

module IF_ID_REGISTER
(
   input wire clk,
   input wire reset,

   input wire if_id_write,
   input wire flush,

   input wire [31:0] pc,
   input wire [31:0] instruction,

   output reg [31:0] if_id_pc,
   output reg [31:0] if_id_instruction
);

always @(posedge clk) begin

   if (reset) begin

      if_id_pc          <= 32'd0;
      if_id_instruction <= 32'd0;

   end

   else if (flush) begin

      if_id_pc          <= 32'd0;
      if_id_instruction <= 32'd0;

   end

   else if (if_id_write) begin

      if_id_pc          <= pc;
      if_id_instruction <= instruction;

   end

end

endmodule
	 
	