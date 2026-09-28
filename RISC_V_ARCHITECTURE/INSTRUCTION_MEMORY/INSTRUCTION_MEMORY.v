// INSTRUCTION MEMORY MODULE 	


// INSTRUCTION MEMORY

module INSTRUCTION_MEMORY
(
   input wire [31:0] pc,
   output wire [31:0] instruction
);

reg [31:0] instruction_memory [0:255];



initial begin

   $readmemh("program.hex", instruction_memory);

end



assign instruction = instruction_memory[pc[9:2]];

endmodule