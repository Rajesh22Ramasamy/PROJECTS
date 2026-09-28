// PROGRAM COUNTER


module PROGRAM_COUNTER
(
   input wire clk,
   input wire reset,
   input wire pc_write,

   input wire [31:0] pc_next,

   output reg [31:0] pc
);

always @(posedge clk) begin

   if (reset) begin
      pc <= 32'd0;
   end

   else if (pc_write) begin
      pc <= pc_next;
   end

end

endmodule
	