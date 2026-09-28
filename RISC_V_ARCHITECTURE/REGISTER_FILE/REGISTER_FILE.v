// REGISTER FILE



module REGISTER_FILE
(
   input wire clk,
   input wire reset,

   input wire [4:0] rs1,
   input wire [4:0] rs2,

   input wire [4:0] rd,
   input wire [31:0] write_data,
   input wire reg_write,

   output wire [31:0] read_data1,
   output wire [31:0] read_data2
);

reg [31:0] registers [0:31];

integer i;


assign read_data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
assign read_data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];


always @(posedge clk) begin

   if (reset) begin

      for (i = 0; i < 32; i = i + 1) begin
         registers[i] <= 32'd0;
      end

   end

   else begin

      if (reg_write && (rd != 5'd0)) begin
         registers[rd] <= write_data;
      end

   end

end

endmodule