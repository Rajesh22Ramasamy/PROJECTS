// BRANCH LOGIC

module BRANCH_LOGIC
(
   input wire [31:0] pc,
   input wire [31:0] immediate,
   input wire branch,
   input wire zero,

   output wire [31:0] branch_target,
   output wire branch_taken
);

assign branch_target = pc + immediate;

assign branch_taken = branch & zero;

endmodule