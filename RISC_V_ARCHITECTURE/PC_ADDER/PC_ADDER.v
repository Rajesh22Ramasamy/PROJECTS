// PC_ADDER

module PC_ADDER
(
   input wire [31:0] pc,
   output wire [31:0] pc_next
);

assign pc_next = pc + 4;

endmodule