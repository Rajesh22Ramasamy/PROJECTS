// DATA MEMORY

// Read - Combinational perfomance
// Write - Sequential Perfomance

module DATA_MEMORY
(
   input wire clk,

   input wire mem_read,
   input wire mem_write,

   input wire [31:0] address,
   input wire [31:0] write_data,

   output wire [31:0] read_data
);

// 256 memory elements, each 32 bits
reg [31:0] data_memory [0:255];


// READ OPERATION - Used by LW
assign read_data = mem_read
                 ? data_memory[address[9:2]]
                 : 32'd0;


// WRITE OPERATION - Sequential assignemnt
always @(posedge clk) begin

   if (mem_write) begin
      data_memory[address[9:2]] <= write_data;
   end

end

endmodule